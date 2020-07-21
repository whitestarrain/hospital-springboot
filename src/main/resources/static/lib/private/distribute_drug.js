new Vue({
	el: "#maindiv",
	data: {
		DrugDistribute: [

		],
		date: "",
		recordNum: ""
	},
	methods: {
		/* 成功提示 */
		distribute: function() {
			var _this = this;
			axios.get("/prescription/distributeDrug", {
				params: {
					recordNum: _this.recordNum,
					date: _this.date
				}
			}).then(function(resp) {
				toastr["success"]("发药成功!")
				_this.getInfo()
			})
		},
		confirm: function() {
			var _this = this;
			var popup = new Popup({
				'type': 'submit',
				'title': '确认',
				'text': '确认要发药吗？',
				'cancelbutton': true,
				'closeCallBack': function() {

				},
				'submitCallBack': function() {
					//TODO
					_this.distribute()

				}
			})
		},
		getInfo: function() {
			var _this = this;
			axios.get("/VoDrugDistribute/getVoDrugDistributeByNum", {
				params: {
					recordNum: _this.recordNum,
					date: _this.date
				}
			}).then(function(resp) {
				_this.DrugDistribute = resp.data
			})
		}
	}

});

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
