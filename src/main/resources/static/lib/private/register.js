toastr.options = {
	"closeButton": true,
	"debug": false,
	"newestOnTop": false,
	"progressBar": false,
	"positionClass": "toast-top-center",
	"preventDuplicates": false,
	"onclick": null,
	"showDuration": "300",
	"hideDuration": "1000",
	"timeOut": "2000",
	"extendedTimeOut": "1000",
	"showEasing": "swing",
	"hideEasing": "linear",
	"showMethod": "fadeIn",
	"hideMethod": "fadeOut"
}

new Vue({
	el: "#registerdiv",
	data: {
		registerdata: {
			medicalRecord: "",
			name: "",
			gender: "",
			idNumber: "",
			birthday: "",
			payWay: 1,
			address: "",
			diagDate: "",
			noon: "上",
			depaId: 1,
			doctorId: 0,
			needRecord: true,
		},
		invoiceNum: "挂号后生成",
		registerLevel: 1,
		doctors: [{

		}],
		limitNum: "",
		useNum: "0",
		registerPrice: 20 //可以改成从服务端获取
	},
	methods: {
		autoInput: function() {
			var _this = this;
			axios.get("/register/getRegisterByMedicalRecord", {
				params: {
					medicalRecord: _this.registerdata.medicalRecord
				}
			}).then(function(resp) {
				if (resp.data.length !== 0) {
					_this.registerdata.name = resp.data.name;
					_this.registerdata.gender = resp.data.gender;
					_this.registerdata.idNumber = resp.data.idNumber;
					_this.registerdata.address = resp.data.address;
					_this.registerdata.birthday = resp.data.birthday;
					_this.registerdata.needRecord = false;
				} else {
					_this.registerdata.needRecord = true;
				}
			})
		},
		getDoc: function() {
			var _this = this;
			axios.get("/user/getUserByDepAndLevel", {
				params: {
					depaId: _this.registerdata.depaId,
					levelId: _this.registerLevel
				}
			}).then(function(response) {
				_this.doctors = response.data;
				_this.limitNum = _this.registerLevel == 1 ? 20 : 30
			})
		},
		registerFun: function() {
			var _this = this;

			// 从上层获取用户id
			var a = window.parent.document.getElementById("user-id").innerText;
			axios.get("/register/doRegister", {
				params: {
					medicalRecord: _this.registerdata.medicalRecord,
					name: _this.registerdata.name,
					gender: _this.registerdata.gender,
					idNumber: _this.registerdata.idNumber,
					birthday: _this.registerdata.birthday,
					payWay: _this.registerdata.payWay,
					address: _this.registerdata.address,
					diagDate: _this.registerdata.diagDate,
					noon: _this.registerdata.noon,
					depaId: _this.registerdata.depaId,
					doctorId: _this.registerdata.doctorId,
					needRecord: _this.registerdata.needRecord == true ? 1 : 0,
					status: 1, //默认正常
					registrarId: a
				}
			}).then(function(resp) {
				_this.invoiceNum = resp.data
				toastr["success"]("挂号成功!");
				_this.setUseNum()
			})
		},
		setUseNum: function() {
			// 设置已用号额
			var _this = this;
			axios.get("/register/getRegistedNumByDocId", {
				params: {
					id: _this.registerdata.doctorId
				}
			}).then(function(resp) {
				_this.useNum = resp.data
				if (resp.data >= _this.limitNum) {
					$("#registerbtn").prop({
						disabled: true
					})
				}
			})
		},
		chongzhi: function() {
			this.registerdata.doctorId = 0
		}
	}
})


/* 信息验证 */
var vertifacation = function() {
	var flag = true;
	$("#registerdiv input").each(function() {
		// console.log($(this).val())
		if ($(this).val() == null || $(this).val() == undefined) {
			flag = false;
		}
	})
	$("#registerdiv select").each(function() {
		// console.log($(this).val())
		if ($(this).val() == null || $(this).val() == undefined) {
			flag = false;
		}
	})
	// console.log($("#selectdoctorid").val())
	if ($("#selectdoctorid").val() == null || $("#selectdoctorid").val() == undefined || $("#selectdoctorid").val() ==
		0) {
		flag = false
	}
	$("#registerbtn").prop({
		disabled: !flag
	})
}

$("#registerdiv input,select").blur(vertifacation)
$("#registerdiv input,select").mouseleave(vertifacation)
