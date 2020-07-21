new Vue({
	el: "#bodyContainer",
	data: {
		recordNum: "", // 病历号
		register: { // 当前选中Register的信息显示
			id: "",
			name: "",
			address: "",
			idNumber: "",
			payWay: 1
		},
		selectRegisterId: 0,
		registerIds: [],
		consumeInfo: [],
		allMoney: 0,
		payMoney: 0,
		returnMoney: 0,
		invoiceNum: "",
		user_id: ""
	},
	methods: {
		getInfo: function(r) { // 设置页面基本信息
			var _this = this
			var id = r
			axios.get("/register/getRegisterById", {
				params: {
					registerId: id
				}
			}).then(function(resp) {
				// 获取信息
				_this.register = resp.data
			})
		},
		getConsumeInfo: function(r) { // 设置消费信息
			var _this = this
			var id = r
			axios.get("/voConsumeInfo/getInfoByRegisterId", {
				params: {
					registerId: id
				}
			}).then(function(resp) {
				// 获取信息
				var info = resp.data;
				var sum = 0;
				_this.consumeInfo = info
				for (var i = 0; i < info.length; i++) {
					sum += parseFloat(info[i].presPrice)
				}
				if (info.length == 0) {
					$("#Settlement").prop({
						disabled: true
					})
				} else {
					if (info.length > 0) {
						if (info[0].status != 1) { // 只有未缴费的可以缴费
							$("#Settlement").prop({
								disabled: true
							})
						}
					}

				}
				// 设置金钱总额
				_this.allMoney = sum.toFixed(2)
				// 付钱初始化为0
				_this.payMoney = 0
				// 刷新应找回金钱
				_this.getReturnMoney();
			})
		},
		getInfoAndConsumeInfo: function() { // 设置页面基本信息和消费信息
			if (this.selectRegisterId == 0) {
				return
			}
			$("#Settlement").prop({
				disabled: false
			})
			this.getInfo(this.selectRegisterId)
			this.getConsumeInfo(this.selectRegisterId)
		},
		getRegisterIds: function() {
			var _this = this
			axios.get("/register/getRegisterIdsByRecordNum", {
				params: {
					recordNum: _this.recordNum
				}
			}).then(function(resp) {
				_this.registerIds = resp.data
			})
		},
		pay: function() {
			var _this = this
			// 进行支付
			axios.get("/prescription/pay", {
				params: {
					userId: _this.user_id,
					payWay: _this.register.payWay,
					registerId: _this.register.id
				}
			}).then(function(resp) {
				// 更新支付状态
				_this.getInfoAndConsumeInfo();
				// 设置发票号
				_this.invoiceNum = resp.data
				toastr["success"]("支付成功，发票号为" + _this.invoiceNum + "")
				$("#Settlement").prop({
					disabled: true // 缴费后不能再缴费
				})
			})

		},
		getReturnMoney: function() {
			if (this.payMoney == null || this.payMoney === "") {
				return
			}
			if (this.payMoney - this.allMoney < 0) {
				this.returnMoney = "支付不足"
				$("#payfeebtn").prop({
					disabled: true
				})
				return
			}
			$("#payfeebtn").prop({
				disabled: false
			})
			this.returnMoney = (this.payMoney - this.allMoney).toFixed(2)
		}
	},
	beforeMount: function() {
		// 从上层获取用户id
		var a = window.parent.document.getElementById("user-id").innerText;
		this.user_id = a
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
	"timeOut": "10000",
	"extendedTimeOut": "1000",
	"showEasing": "swing",
	"hideEasing": "linear",
	"showMethod": "fadeIn",
	"hideMethod": "fadeOut"
}

// 结算信息（表单）弹出
$("#Settlement").click(function() {
	$("#invoice-Modal").modal()
})
