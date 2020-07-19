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
		},
		initialization: function() {
			//初始化处方表
			var _this = this
			axios.get("/prescription/getAll").then(function(resp) {
				_this.prescriptions = resp.data
				_this.selectedPrescriptionDrugs = []
			})
		}
	},
	beforeMount: function() {
		//初始化处方表
		var _this = this
		axios.get("/prescription/getAll").then(function(resp) {
			_this.prescriptions = resp.data
			_this.selectedPrescriptionDrugs = []
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
				}
				document.getElementById("allmoney").innerHTML = parseFloat(sum.toFixed(2))
			})

		}
	}
})

new Vue({
	el: "#addDrugTable",
	data: {
		drugList: [{
			drugCode: "",
			id: "",
			name: "",
			specification: "",
			price: "",
			pack: "",
			form: "",
			type: ""
		}],
		mess: {

		}
	},
	methods: {
		addDrug: function(a) { // 设置当前选中药品id到隐藏域中
			var drugId = a;
			// flag用来记录是否有选中的处方
			var flag = false;
			var prescriptionIdV;
			var radios = $("#selectedPrescriptions input[type=radio]")
			for (var i = 0; i < radios.length; i++) {
				if (radios[i].checked) {
					flag = true;
					break;
				}
			}

			// 没有选中处方时跳出
			if (!flag) {
				toastr["info"]("请选择处方id")
				return
			}
			var selectedDrug;
			for (var i = 0; i < this.drugList.length; i++) {
				if (this.drugList[i].id = drugId) {
					selectedDrug = this.drugList[i]
					break;
				}
			}
			$("#selectedDrug").val(selectedDrug.id)

			var div = $("#addDrugDetails")[0]
			// 设置信息
			div.querySelector("div[class='form-group row']:nth-child(1)>div:nth-child(2)>input").value = selectedDrug.drugCode
			div.querySelector("div[class='form-group row']:nth-child(2)>div:nth-child(2)>input").value = selectedDrug.name
			div.querySelector("div[class='form-group row']:nth-child(3)>div:nth-child(2)>input").value = selectedDrug.specification
			div.querySelector("div[class='form-group row']:nth-child(4)>div:nth-child(2)>input").value = selectedDrug.pack


			// 弹出药品模版详细界面
			$("#use-drug-Modal").modal()



		}
	},
	beforeMount: function() {
		var _this = this
		axios.get("/drug/getDrugDetails").then(function(resp) {
			_this.drugList = resp.data
		})
	}
})

function adddrugbtnListener(event) {

	var prescriptionId;
	var radios = $("#selectedPrescriptions input[type=radio]")
	// 获得当前处方id
	for (var i = 0; i < radios.length; i++) {
		if (radios[i].checked) {
			prescriptionId = ($(radios[i]).parent().parent().children())[0].value
			break;
		}
	}
	var drugId = $("#selectedDrug").val()


	var div = $("#addDrugDetails")[0]
	// 	TODO
	// 从页面搜取必要信息
	var useWay = div.querySelector("div[class='form-group row']:nth-child(5)>div:nth-child(2)>input").value
	var dosage = div.querySelector("div[class='form-group row']:nth-child(6)>div:nth-child(2)>input").value
	var frequency = div.querySelector("div[class='form-group row']:nth-child(7)>div:nth-child(2)>input").value
	var number = div.querySelector("div[class='form-group row']:nth-child(8)>div:nth-child(2)>input").value
	// ajax请求，数据库插入
	axios.get("/drug/insertDrugTemplate", {
		params: {
			presId: prescriptionId,
			"drugId": drugId,
			"useWay": useWay,
			"dosage": dosage,
			"frequency": frequency,
			"number": number
		}
	}).then(function(resp) {
		if (resp.data > 0) {
			toastr["error"]("不能添加重复药品")
		} else {
			toastr["success"]("添加成功")
			// 右上table数据更新:updateRightTop函数
			updateRightTop()
		}

		// 表格内数据可以清除
		div.querySelector("div[class='form-group row']:nth-child(5)>div:nth-child(2)>input").value = ""
		div.querySelector("div[class='form-group row']:nth-child(6)>div:nth-child(2)>input").value = ""
		div.querySelector("div[class='form-group row']:nth-child(7)>div:nth-child(2)>input").value = ""
		div.querySelector("div[class='form-group row']:nth-child(8)>div:nth-child(2)>input").value = ""

		//关闭药品选择框
		$("#drugs").slideToggle("fast")
	})

}

$("#adddurgbtn").click(adddrugbtnListener)

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

	var tr = "<tr><input type='hidden' value='" + $(a[0]).val() +
		"'/><td style='width:10%'><input type='radio' name='pres'></td><td style='width:60%'>" + a[
			1].innerHTML +
		"</td><td style='width:10%'>暂存</td></tr>"
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
			name: nameval
		}

	}).then(function(resp) {
		var name = $("#newPrescriptionName").val();
		var id = resp.data
		var tr = "<tr><input type='hidden' value='" + id + "'/><td><input type='radio' name='pres'></td><td>" + name +
			"</td><td>暂存</td></tr>"

		// 清除数据
		$("#newPrescriptionName").val("");

		// 左下重新初始化

		reinitializationLeftDown()
		$("#selectedPrescriptions").append(tr)
		toastr["success"]("添加成功!")
	})
})

function reinitializationLeftDown() {

	// 左下，重新初始化。右下侧也会删除数据
	document.getElementById("initializationbtn").click()
	// 删除选中样式
	$("#prescriptionTable tr").removeClass("info")
	// 重新设置点击事件
	setTimeout(setEffect, 200);
}

// 进行开立
$("#kaili").click(function() {
	var radios = $("#selectedPrescriptions input[type=hidden]")
	var arr_str = ""
	var rid = window.parent.document.getElementById("registerId").innerHTML;
	if (radios.length == 0) {
		toastr["info"]("您未选择处方，请选择")
		return
	}
	for (var i = 0; i < radios.length; i++) {
		// 获取左上所有处方id
		arr_str = arr_str + $(radios[i]).val() + ","
	}
	// 去掉最后一个逗号
	var str = arr_str.substring(0, arr_str.length - 1)
	// 请求插入
	axios.get("/prescription/doPrescription", {
		params: {
			registerId: rid,
			ids: str
		}
	}).then(function() {
		toastr["success"]("开立成功")
		// 遮罩层
		showOverlay();
		// 左侧数据刷新
		setTimeout(function() {
			window.parent.document.getElementById("refreshbtn").click()
		}, 200)
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



$("#cancelAddDrug").click(function() {
	$("#drugs").slideToggle("fast")
})


// 诊毕患者的处理
setTimeout(function() {
	var Selectedstatus = window.parent.document.getElementById("Selectedstatus").innerHTML;
	var rid = window.parent.document.getElementById("registerId").innerHTML;
	var _this = this
	// 显示诊毕患者的记录
	if (Selectedstatus == 3) {
		axios.get("/prescription/getPrescripted", {
			params: {
				registerId: rid
			}
		}).then(function(resp) {
			var tr;
			var list = resp.data;
			var table = $("#selectedPrescriptions")
			for (var i = 0; i < list.length; i++) {
				tr = "<tr><td style='width: 10%;'></td><td style='width: 60%;'>" + list[i] +
					"</td><td style='width: 30%;'>已提交</td></tr>"
				table.append($(tr))
			}
		})
		showOverlay()
	}
}, 200)

function showOverlay() {
	var winWidth = window.innerWidth
	$('.overlay').css({
		'height': document.scrollingElement.scrollHeight,
		'width': winWidth - 20
	});
	$('.overlay').show();
}

// 作废也就是重新加载
$("#zuofei").click(function() {
	window.parent.document.getElementById("chengyaochufang").click()
})
