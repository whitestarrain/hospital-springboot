//设置最上面诊断的信息
new Vue({
	el: "#diagnose-info",
	data: {
		message: ""
	},
	beforeMount: function() {
		var _this = this
		var rid = window.parent.document.getElementById("registerId").innerHTML;
		axios.get("/diagnose/WesternDiagnose", {
			params: {
				registerId: rid
			}
		}).then(function(resp) {
			if (resp.data.toString().length > 0) {
				_this.message = "[西医诊断]" + resp.data.diseaseName
				return
			}
		})
		axios.get("/diagnose/ChineseDiagnose", {
			params: {
				registerId: rid
			}
		}).then(function(resp) {
			if (resp.data.toString().length > 0) {
				_this.message = "[中医诊断] " + resp.data.diseaseName
				return
			}
		})
	}
})

new Vue({
	el: "#right-down-part",
	data: {
		prescriptions: [{
			id: "",
			name: "",
			docId: "",
			creatDate: "",
			range: ""
		}],
		selectedPrescriptionDrugs: [{
			name: "",
			specification: "",
			useWay: "",
			dosage: "",
			frequency: "",
			number: "",
			price: ""
		}]
	},
	methods: {
		//根据处方id设置右侧模版明细
		setTemplate: function(a) {
			var _this = this
			axios.get("/prescription/getTemplate", {
				params: {
					id: a
				}
			}).then(function(resp) {
				_this.selectedPrescriptionDrugs = resp.data
			})
		}
	},
	beforeMount: function() {
		var _this = this
		axios.get("/prescription/getAll").then(function(resp) {
			_this.prescriptions = resp.data
		})
	}
})

/* 处方列表添加点击后效果事件 */
function setEffect() {
	$("#prescriptionTable tr").click(function(e) {
		$("#prescriptionTable tr").removeClass("info")
		$(this).addClass("info")
		//第一行为标题，不能高亮
		$("#prescriptionTable tr:first").removeClass("info")
	})
}
//为vue留出时间
setTimeout(setEffect, 200);


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
$('#use-pres').click(function() {
	var popup = new Popup({
		'type': 'submit',
		'title': '确认',
		'text': '确认要添加模版吗？',
		'cancelbutton': true,
		'closeCallBack': function() {
			// alert('点击了关闭')
		},
		'submitCallBack': appendPrescription
	})
})

// 将处方添加到左上去
var appendPrescription = function() {
	//TODO
	var a = $("#prescriptionTable tr.info *")

	var tr = "<tr><inputtype='hidden' value='" + a[0].value + "'/><td><input type='radio' name='pres'></td><td>" + a[1].innerHTML +
		"</td><td>暂存</td></tr>"
	$("#selectedPrescriptions").append(tr)
	toastr["success"]("添加成功!")
}
// 删除选中的
var removeSelectedPrescription = function() {
	// TODO 待修改
	var radios = $("#selectedPrescriptions input")
	for (var i = 0; i < radios.length; i++) {
		console.log(radios[i].checked)
		if (radios[i].checked) {
			console.log(radio)
			radio.parent().parent().remove()

		}

	}
}
$("#deleteSelectedPrescriptinon").click(removeSelectedPrescription)


// TODO 搜索功能（模版选做）

// TODO 处方模版中，选择处方时效果变化（自己写个css的class），模版明细的显示




$("#create-pres").click(function() {
	$("#create-pres-Modal").modal()
})
// TODO 确认增方后删除modal中的数据，添加到处方栏中
// TODO 取消增方后删除数据


$("#add-drug").click(function() {
	$("#drugs").slideToggle("slow")
})
$("#cancel-select").click(function() {
	$("#drugs").slideToggle("slow")
})

// TODO 加药弹窗
$("#drugs>div button").click(function() {
	// TODO 获取药品信息填入
	$("#use-drug-Modal").modal()
})

$("#adddurgbtn").click(function() {
	$("#drugs").slideToggle("fast")
})
