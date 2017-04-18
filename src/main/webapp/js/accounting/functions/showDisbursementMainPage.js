/**
 * Shows Disbursement Main Page Module: GIACS016
 * 
 * @author niknok
 * @date 05.28.2012
 */
function showDisbursementMainPage(disbursement, refId, otherBranch){   //added otherBranch - Halley 11.13.13
	try{
		if (checkUserModule("GIACS016") == false){
			showMessageBox(objCommonMessage.NO_MODULE_ACCESS, "E");
			return false;
		}	
		new Ajax.Request(contextPath+"/GIACPaytRequestsController",{
			parameters: {
				action: "showMainDisbursementPage",
				disbursement: disbursement,
				refId: refId,
				newRec: (nvl(refId,null) == null ? "Y" : "N"),
				branch: otherBranch  //Halley 11.13.13
			},
			asynchronous : false,
			evalScripts : true,
			onCreate : function() {
				showNotice("Getting Disbursement Page, please wait...");
			},
			onComplete : function(response) {
				if (checkErrorOnResponse(response)) {
					hideAccountingMainMenus();
					$("mainContents").update(response.responseText);
				}
			}
		});
	} catch (e) {
		showErrorMessage("showDisbursementMainPage", e);
	}
}