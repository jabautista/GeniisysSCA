/**
 * @author rey
 * @date 09-09-2011
 * for exit with same line
 */
function showClaimListing(){
	//initializeMenu(); 
	if($("claimListingMainDiv") != null){ // added by andrew - 02.24.2012 - show the claim listing div, refresh the list, and clear the objCLMGlobal
		setModuleId("GICLS002");
		setDocumentTitle("Claim Listing");
		$("claimListingMainDiv").show();
		$("claimInfoDiv").innerHTML = "";		
		claimsListTableGrid.refresh();
		objCLMGlobal = new Object();
	} else {
		new Ajax.Updater("dynamicDiv", contextPath + "/GICLClaimsController?action=getClaimTableGridListing", {
			method: "GET",
			asynchronous: true,
			evalScripts: true,
			parameters : {
				action : "getClaimTableGridListing",
				lineCd : objCLMGlobal.lineCd,
				lineName: objCLMGlobal.lineName
			},
			onCreate : function() {
				showNotice("Loading, please wait...");
			},
			onComplete: function (response){
				hideNotice("");
			}
		});
	}
}