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

// 初始化
$(function() {
	var b = window.innerHeight;
	/* body高度 */
	$("body").css({
		height: b
	});


	//疾病表单中的取消键
	$("#cancel-select").click(function() {
		toggleDisease();
	})
});

//切换显示疾病弹窗
function toggleDisease(a) {
	// a用来接收是中医还是西医
	$("#diease").slideToggle("slow");
}

// 提交病历
$(".submitbtn").click(function() {
	// TODO ajax业务操作

	toastr["success"]("挂号成功!")
})

new Vue({
	el: "#diseasetable",
	data: {
		diseases: [{
			name: 2111,
			id: 121,
			icd: 1121,
			type: 1112,
			typeId: 1111
		}],
		selectDiseaseId: "" //已绑定，可通过id可获取
	},
	methods: {
		/* 按钮点击时更改已选疾病id */
		selectDisease: function(id) {
			this.selectDiseaseId = id;
		}
	},
	beforeMount: function() {
		var _this = this;
		axios.get("/disease/getDiseases").then(function(resp) {
			_this.diseases = resp.data
		})
	}
})
new Vue({
	el: "#medicalrecord",
	data: {
		medicalrecord: {
			recordNum: "",
			symptom: "",
			nowHistory: "",
			anamnesis: "",
			allergyhis: "",
			treatment: "",
			checkup: "",
			checkSugg: "",
			attention: "",
		},
		diagnoseType: "", //已绑定，可通过id可获取
		ChineseDiagnose: {
			// diseaseName: "111",
			// diagnoseDate: "2000-01-01",
			// icd: "1111"
		},
		WesternDiagnose: {
			// diseaseName: "111",
			// diagnoseDate: "2000-01-01",
			// icd: "1111"
		}
	},
	methods: {
		// 诊断数据提交
		submit: function() {
			var _this = this;
			var o = window.parent.document.getElementById("recordNum").innerHTML;
			var a = window.parent.document.getElementById("registerId").innerHTML;
			var b = _this.diagnoseType
			var c = document.getElementById("selectDiseaseId").value
			//两个axios提交
			axios.get("/medicalRecord/add", {
				params: {
					recordNum: o,
					symptom: _this.medicalrecord.symptom,
					nowHistory: _this.medicalrecord.nowHistory,
					anamnesis: _this.medicalrecord.anamnesis,
					allergyhis: _this.medicalrecord.allergyhis,
					treatment: _this.medicalrecord.treatment,
					checkup: _this.medicalrecord.checkup,
					checkSugg: _this.medicalrecord.checkSugg,
					attention: _this.medicalrecord.attention
				}
			})

			axios.get("/diagnose/doDiagnose", {
				params: {
					registerId: a,
					diagnoseType: b,
					selectDiseaseId: c
				}
			})

			// 弹出刷新成功
			toastr["success"]("提交成功!")

			//禁止更改
			$("#medicalrecord *").prop({
				disabled: true
			})

			// 调用左侧刷新
			setTimeout(function() {
				window.parent.document.getElementById("refreshbtn").click()
			}, 200) //200毫秒给vue缓冲

		},
		setDiagnoseType: function(a) {
			var Selectedstatus = window.parent.document.getElementById("Selectedstatus").innerHTML;
			if (Selectedstatus == 1) {
				toggleDisease(a)
				this.diagnoseType = a;
			}
		}
	},
	beforeMount: function() {
		/* 记录病历号 */
		var recordNumVal = window.parent.document.getElementById("recordNum").innerHTML;
		var rid = window.parent.document.getElementById("registerId").innerHTML;
		var _this = this;
		axios.get("/medicalRecord/getByNum", {
			params: {
				recordNum: recordNumVal
			}
		}).then(function(resp) {
			_this.medicalrecord = resp.data;
		})
		axios.get("/diagnose/ChineseDiagnose", {
			params: {
				registerId: rid
			}
		}).then(function(resp) {
			_this.ChineseDiagnose = resp.data
		})
		axios.get("/diagnose/WesternDiagnose", {
			params: {
				registerId: rid
			}
		}).then(function(resp) {
			_this.WesternDiagnose = resp.data
		})

	}
})

/* 已诊的话就不能再改了 */

$(function() {
	setTimeout(function() {
		var Selectedstatus = window.parent.document.getElementById("Selectedstatus").innerHTML;
		if (Selectedstatus == 2 || Selectedstatus == 3) {
			$("#medicalrecord *").prop({
				disabled: true
			})
		}
	}, 200)
})

/* 为选择按钮添加事件，使数据移动 */
$(function() {
	setTimeout(function() {
		$("#disease-page button").click(function(e) {



			var btn = e.target
			var a = $(btn).parent().siblings()
			var zx = $("#diagnoseType").val();
			var tr = $(
				"<tr><td class='col-sm-1'><div class='checkbox'><input type='checkbox' /></div></td><td class='col-sm-1'>" +
				a[0].innerHTML + "</td><td class='col-sm-3'>" + a[1].innerHTML +
				"</td><td class='col-sm-5'></td><td class='col-sm-2'><input type='date' /></td></tr>")

			// 清除内容
			var trsxiyi = $("#xiyitable").find("tr");
			var trszhongyi = $("#zhongyitable").find("tr");
			for (var i = 1; i < trsxiyi.length; i++) {
				$(trsxiyi[i]).remove()
			}
			for (var i = 1; i < trszhongyi.length; i++) {
				$(trszhongyi[i]).remove()
			}
			if (zx == 1) {
				$("#xiyitable").append(tr)
			} else {
				$("#zhongyitable").append(tr);
			}

			/* 关闭页面 */
			toggleDisease(a)
		})
	}, 500) // 为vue预留时间

})

// 跨层获取数据
// var Selectedstatus = window.parent.document.getElementById("Selectedstatus").innerHTML;
// var registerId = window.parent.document.getElementById("registerId").innerHTML;
// var recordNum = window.parent.document.getElementById("recordNum").innerHTML;
// console.log(Selectedstatus)
// console.log(registerId)
// console.log(recordNum)
