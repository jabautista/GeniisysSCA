/**
 *  @author Steven Ramirez
 *  @date 08.13.2013
 *  @description Shows the GIACS221/Commission Inquiry.
 */
function showCommissionInquiry(callingForm,issCd,premSeqNo,intmNo) {
	try{
		new Ajax.Request(contextPath+"/GIACInquiryController",{
			method: "POST",
			parameters : {action : "showCommissionInquiry"},
			asynchronous: false,
			evalScripts: true,
			onCreate: function (){
				showNotice("Loading, please wait...");
			},
			onComplete: function(response){
				hideNotice();
				if (checkErrorOnResponse(response)){
					if (objACGlobal.previousModule == "GIACS288"){
						$("otherModuleDiv").update(response.responseText);
						$("otherModuleDiv").show();
						$("billsByIntmMainDiv").hide();
					}else{
						$("dynamicDiv").update(response.responseText);
					}
					objACGlobal.hideGIACS221Obj = {};
					objACGlobal.callingForm = callingForm;
					objACGlobal.hideGIACS221Obj.issCd = issCd;
					objACGlobal.hideGIACS221Obj.premSeqNo = premSeqNo;
					objACGlobal.hideGIACS221Obj.intmNo = nvl(intmNo,"");
				}
			}
		});
	} catch(e){
		showErrorMessage("showCommissionInquiry", e);
	}
}