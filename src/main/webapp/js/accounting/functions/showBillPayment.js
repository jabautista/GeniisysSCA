/**
 * @author Steven Ramirez
 * @date 04.27.2013
 * @description Shows the GIACS211/Bill Payments.
 */
function showBillPayment(callingForm, issCd, premSeqNo, intmNo) { //added by steven 10.28.2014 "intmNo"
	try {
		new Ajax.Request(contextPath + "/GIACInquiryController", {
			method : "POST",
			parameters : {
				action : "showBillPayment"
			},
			asynchronous : false,
			evalScripts : true,
			onCreate : function() {
				showNotice("Loading, please wait...");
			},
			onComplete : function(response) {
				hideNotice();
				if (checkErrorOnResponse(response)) {
					if (objACGlobal.previousModule == "GIACS288"){
						$("otherModuleDiv").update(response.responseText);
						$("otherModuleDiv").show();
						$("billsByIntmMainDiv").hide();
					}else{
						$("dynamicDiv").update(response.responseText);
					}
					objACGlobal.hideGIACS211Obj = {};
					objACGlobal.callingForm = callingForm;
					objACGlobal.hideGIACS211Obj.issCd = issCd;
					objACGlobal.hideGIACS211Obj.premSeqNo = premSeqNo;
					objACGlobal.hideGIACS211Obj.intmNo = nvl(intmNo,"");
				}
			}
		});
	} catch (e) {
		showErrorMessage("showBillPayment", e);
	}
}