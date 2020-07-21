$(function() {
	var h = window.innerHeight
	$("#right-part").css({
		height: h * 0.92
	})
	$("#right-down-part").css({
		height: h * 0.77
	})

})

new Vue({
	el: "#left-part",
	data: {
		noDiagnosedRegister: [{
			name: "test",
			age: 11,
			medicalRecord: 231313,
			gender: "男",
			id: 1,
			status: 1

		}],
		diagnosedRegister: [{
			name: "test",
			age: 11,
			medicalRecord: 231313,
			gender: "女",
			id: 1,
			status: 2
		}]
	},
	methods: {
		refreshRegister: function() {
			var _this = this;
			axios.get("/register/getCurrentNoDiagnoseRegister").then(function(resp) {
				_this.noDiagnosedRegister = resp.data
			})
			axios.get("/register/getCurrentDiagnosedRegister").then(function(resp) {
				_this.diagnosedRegister = resp.data
			})

			/* 刷新时,事件重新绑定 */
			setTimeout(tableClick, 300)
		}
	},
	beforeMount: function() {
		var _this = this;
		axios.get("/register/getCurrentNoDiagnoseRegister").then(function(resp) {
			_this.noDiagnosedRegister = resp.data
		})
		axios.get("/register/getCurrentDiagnosedRegister").then(function(resp) {
			_this.diagnosedRegister = resp.data
		})
	}

})

/* 左侧列表添加点击事件 */
var tableClick = function() {

	$("#left-down-part table tr").click(function(e) {
		/* 一旦点击左侧后是病历首页可点 */
		$("#diagnose_medicalReocrd_UpTo_a").prop({
			href: "javascript:diagnose_medicalReocrd_UpTo()"
		})

		// 左侧效果变化
		$("#register-info").show()
		$("#left-down-part table tr").removeClass("info")
		$(this).addClass("info")
		// 注意，因为是css选择器，要从1开始
		for (var i = 1; i <= 6; i++) {
			var a = this.querySelector("td:nth-child(" + i + ")")
			var b = document.querySelector("#register-info>span:nth-child(" + i + ")");
			b.innerHTML = a.innerHTML
		}
		var temp = this.querySelector("td:nth-child(4)");
		document.querySelector("#register-info>span:nth-child(4)").innerHTML = temp.innerHTML == 71 ? '男' : '女',

			// $("#diagnoseIframe").prop({
			// 	src: "./MedicalRecord.html"
			// })
			// 代替
			document.getElementById("diagnose_medicalReocrd_UpTo_a").click()


		/* 成药处方界面不是随便进的 */
		$("#chengyaochufang").prop({
			href: "javascript:void(0)"
		})

		/* 根据状态使成药处方选项可点 */
		var status = document.querySelector("#Selectedstatus").innerText;

		if (status == 2 || status == 3) {
			$("#chengyaochufang").prop({
				href: "javascript:diagnose_Prescription_UpTo()"
			})
		}

	})
}

$(function() {
	setTimeout(tableClick, 300)
	/* 300毫秒给vue准备 */

})
