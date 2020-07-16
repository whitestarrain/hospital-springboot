new Vue({
	el: "#drug-pee-table",
	data: {
		drugs: [{
				drugName: "药品1",
				price: 20,
				number: 2,
				status: 3,
				doctor: "华佗",
				presName: "处方1",
				openDate: "2000-01-01"
			},
			{
				drugName: "药品1",
				price: 20,
				number: 2,
				status: 3,
				doctor: "华佗",
				presName: "处方1",
				openDate: "2000-01-01"
			},
			{
				drugName: "药品1",
				price: 20,
				number: 2,
				status: 3,
				doctor: "华佗",
				presName: "处方1",
				openDate: "2000-01-01"
			}
		]
	},
	methods:{
		/* 成功提示 */
		success:function(){
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
			toastr["success"]("发药成功!")
		},
		confirm:function(){
			var _this=this;
			var popup = new Popup({
				'type': 'submit',
				'title': '确认',
				'text': '确认要发药吗？',
				'cancelbutton': true,
				'closeCallBack': function () {
					//TODO回调函数待完成
					alert('点击了关闭')
				},
				'submitCallBack': function () {
					//TODO
					_this.success()
			
				}
			})
		}
	}

});

