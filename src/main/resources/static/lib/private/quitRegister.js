new Vue({
	el: "#maindiv",
	data: {
		recordNum: "",
		register: {
			id: "",
			name: "",
			address: "",
			idNumber: "",
		},
		registerList: [

		]
	},
	methods: {
		getInfo: function() { // 设置页面基本信息
			var _this = this
			axios.get("/register/getRegisterByMedicalRecord", {
				params: {
					medicalRecord: _this.recordNum
				}
			}).then(function(resp) {
				// 获取信息
				_this.register = resp.data
			})
			axios.get("/voRegister/getRegisterListByNum", {
				params: {
					medicalRecord: _this.recordNum
				}
			}).then(function(resp) {
				_this.registerList = resp.data
			})

		},
		tuihao: function(id) {
			var _this = this;
			axios.get("/register/quitRegister", {
				params: {
					registerId: id
				}
			}).then(function() {
				toastr["success"]("退号成功!");
			})
			_this.getInfo()
		}
	},
	updated: function() {
		var buttons = $("#registerListTable button")
		for (var i = 0; i < buttons.length; i++) {
			if (buttons[i].value != 1) {
				$(buttons[i]).prop({
					disabled: true
				})
			} else {
				$(buttons[i]).prop({
					disabled: false
				})
			}
		}
	}

})

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
	"timeOut": "3000",
	"extendedTimeOut": "1000",
	"showEasing": "swing",
	"hideEasing": "linear",
	"showMethod": "fadeIn",
	"hideMethod": "fadeOut"
}
