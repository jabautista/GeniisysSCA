/**General Ledger Control Sub-Account Maintenance*
 * Created by   : Gzelle
 * Date Created : 10-29-2015
 * Remarks      : KB#132 - Accounting - AP/AR Enhancement
 * */
function showGiacs341(ledgerCd, ledgerDesc){
	new Ajax.Request(contextPath + "/GIACGlSubAccountTypesController", {
	    parameters : {
	    	action : "showGiacs341",
	      ledgerCd : ledgerCd,
	    ledgerDesc : ledgerDesc
	    	},
	    onCreate: showNotice("Retrieving General Ledger Control Sub-Account Type, Please wait..."),
		onComplete : function(response){
			try {
				hideNotice();
				if(checkErrorOnResponse(response)){
//					hideAccountingMainMenus();
					$("dynamicDiv").update(response.responseText);
//					$("acExit").show();
				}
			} catch(e){
				showErrorMessage("showGiacs341 - onComplete : ", e);
			}								
		} 
	});
}