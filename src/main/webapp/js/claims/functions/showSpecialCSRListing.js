/***
 * @description Retrieves the special CSR listing
 * @author Irwin Tabisora
 * @date 12.09.2011
 * @modfied - added parameters branchCd and fundCd when the form is called from GIACS055
 */

function showSpecialCSRListing(fundCd,branchCd , fromClaimItemInfo){
	try{
		
		if(nvl(fromClaimItemInfo,"N") != "Y"){
			objCLMGlobal.claimId = null; //clears claim id global when not from item info
		}
		
		// commented by Kris 08.06.2013 and replaced with the ff:
		if(objGICLS051.previousModule != null && objGICLS051.previousModule == "GICLS051"){
			// left blank.
		} else {
			$("dynamicDiv").down("div",0).hide(); //hide claims menu
		}// end : 08.06.2013

		//changed from mainContents to dynamicDiv by robert 10.24.2013
		new Ajax.Updater(fromClaimItemInfo == "Y" ? "basicInformationMainDiv":"dynamicDiv", contextPath+"/GIACBatchDVController?action=getSpecialCSRListing&moduleId=GIACS086&callingForm="+objCLMGlobal.callingForm+"&claimId="+nvl(objCLMGlobal.claimId,"")+"&branchCd="+nvl(branchCd,""),{
			method : "GET",
			asynchronous: true,
			evalScripts: true,
			onCreate: function() {
				showNotice("Getting Special CSR listing, please wait...");
			},
			onComplete: function(response) {
				hideNotice("");
				if(checkErrorOnResponse(response)){
					if(fromClaimItemInfo != "Y"){
						hideAccountingMainMenus();
						objACGlobal.otherBranchCd = branchCd;
						objACGlobal.callingModule = (objACGlobal.otherBranchCd != null && objACGlobal.otherBranchCd != "" ? "GIACS055" : "GIACS000");
					}
				}
			}
		});
	}catch(e){
		showErrorMessage("showSpecialCSRListing",e);
	}
}