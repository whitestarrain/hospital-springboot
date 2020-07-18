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
			id: "",
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

new Vue({
	el: "#RightTopTable",
	data: {
		drugLists: [{
			id: "",
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
		update: function() {
			var _this = this
			var radios = $("#selectedPrescriptions input[type=hidden]")
			var arr_str = ""
			for (var i = 0; i < radios.length; i++) {
				// 获取左上所有处方id
				arr_str = arr_str + $(radios[i]).val() + ","
			}
			axios.get("/prescription/getTemplateByIds", {
				params: {
					ids: arr_str
				}
			}).then(function(resp) {
				_this.drugLists = resp.data
				var temp = resp.data
				var sum = 0
				for (var i = 0; i < temp.length; i++) {
					sum += parseFloat(temp[i].price) * parseFloat(temp[i].number)
					// 按照所有价格，不可能出现多于两位数的总额
					document.getElementById("allmoney").innerHTML = parseFloat(sum.toFixed(2))
				}
			})

		}
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

	var tr = "<tr><input type='hidden' value='" + $(a[0]).val() + "'/><td><input type='radio' name='pres'></td><td>" + a[
			1].innerHTML +
		"</td><td>暂存</td></tr>"
	$("#selectedPrescriptions").append(tr)
	toastr["success"]("添加成功!")

	// 更新右上角
	updateRightTop()
}

// 更新右上角
function updateRightTop() {
	// 调用vue中的方法
	document.getElementById("drugListsJson").click();
}

// 删除选中的
var removeSelectedPrescription = function() {
	// TODO 待修改
	var radios = $("#selectedPrescriptions input[type=radio]")
	for (var i = 0; i < radios.length; i++) {
		if (radios[i].checked) {
			$(radios[i]).parent().parent().remove()
		}
	}

	// 更新右上角
	updateRightTop()
}
$(function() {
	$("#deleteSelectedPrescriptinon").click(removeSelectedPrescription)
})


// 确认增方后删除modal中的数据，添加到处方栏中

$("#addPrescriptionBtn").click(function() {
	var nameval = $("#newPrescriptionName").val();
	axios.get("/prescription/insertPrescription", {
		params: {
			name:nameval
		}
		
	}).then(function(resp) {
		var name = $("#newPrescriptionName").val();
		var id = resp.data
		var tr = "<tr><input type='hidden' value='" + id + "'/><td><input type='radio' name='pres'></td><td>" + name +
			"</td><td>暂存</td></tr>"

		// 清除数据
		$("#newPrescriptionName").val("");

		$("#selectedPrescriptions").append(tr)
		toastr["success"]("添加成功!")
	})
})




$("#create-pres").click(function() {
	$("#create-pres-Modal").modal()
})


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
