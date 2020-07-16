/// <reference path="../bootstrap/js/jquery-3.5.1.min.js"/>

function diagnose_medicalReocrd_UpTo() {
  $("#right-up-part>ul>li").prop({
    class:""
  })
  $("#right-up-part>ul>li:nth-child(1)").prop({
    class:"active"
  })
  $("#diagnoseIframe").prop({
    src:"./MedicalRecord.html"
  })
}

function diagnose_Prescription_UpTo(){
  $("#right-up-part>ul>li").prop({
    class:""
  })
  $("#right-up-part>ul>li:nth-child(6)").prop({
    class:"active"
  })
  $("#diagnoseIframe").prop({
    src:"./prescription.html"
  })

}