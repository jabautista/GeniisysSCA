/**
 * Observe for main button in Claims Item Information
 * @author niknok
 * @date 11-29-2011
 * @param 
 */
function observeClmItemMainBtn(){
	observeClmItemAttachMedia();
	observeReloadForm("reloadForm", showClaimItemInfo);
	observeSaveForm("btnSave", function(){saveClaimsItemGrid(true);});
	//observeCancelForm("btnCancel", function(){saveClaimsItemGrid(false);}, showClaimListing);
	// commented by Kris 08.06.2013 and replaced with the ff:
	observeCancelForm("btnCancel", function(){saveClaimsItemGrid(false);}, function(){
		if(objGICLS051.previousModule == "GICLS051"){
			showGeneratePLAFLAPage(objGICLS051.currentView, objCLMGlobal.lineCd);
		} else {
			showClaimListing();
		}
	});
	//observeCancelForm("clmExit", function(){saveClaimsItemGrid(false);}, showClaimListing);
	// commented by Kris 08.06.2013 and replaced with the ff:
	observeCancelForm("clmExit", function(){saveClaimsItemGrid(false);}, function(){
		if(objGICLS051.previousModule == "GICLS051"){
			objGICLS051.previousModule = null;
			showGeneratePLAFLAPage(objGICLS051.currentView, objCLMGlobal.lineCd);
		} else {
			showClaimListing();
		}
	});
	changeTag = 0;
	initializeChangeTagBehavior(function(){saveClaimsItemGrid(false);});
	/**
	 * @author rey
	 * @date 04.30.
	 */
	validateItemTableGrid();
}