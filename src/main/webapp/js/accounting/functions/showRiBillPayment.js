/**
 * @Created By : Mikel Razon
 * @Date Created : 06.04.2013
 * @Description Shows the GIACS270/ View RI Payments Per Bill
 */
function showRiBillPayment(callingForm, issCd, premSeqNo) {
	try {
		new Ajax.Request(contextPath + "/GIACReinsuranceInquiryController", {
			method : "POST",
			parameters : {
				action : "showRiBillPayment"
			},
			asynchronous : false,
			evalScripts : true,
			onCreate : function() {
				showNotice("Loading, please wait...");
			},
			onComplete : function(response) {
				hideNotice();
				if (checkErrorOnResponse(response)) {
					$("dynamicDiv").update(response.responseText);
					objACGlobal.hideGIACS270Obj = {};
					objACGlobal.callingForm = callingForm;
					objACGlobal.hideGIACS270Obj.issCd = issCd;
					objACGlobal.hideGIACS270Obj.premSeqNo = premSeqNo;
				}
			}
		});
	} catch (e) {
		showErrorMessage("showRiBillPayment", e);
	}
} // end mikel