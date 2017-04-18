/**
 * Shows the quotation listing
 * @author andrew robes
 * @date 02.09.2012
 */
function showQuotationListing(){	
	enggBasicInfoExitCtr = 0;
	carrierInfoExitCtr = 0;
	assuredMaintainGimmExitCtr = 0;
	if(checkPendingRecordChanges()){ // Patrick 02.15.2012
		$("quoteListingMainDiv").show();
		setModuleId("GIIMM001"); //added by steven 11.07.2013
		setDocumentTitle("Quotation Listing");
		$("quoteInfoDiv").innerHTML = "";
		objGIPIQuote.quoteId = 0;
		quotationTableGrid.refresh();
		changeTag = 0; // Patrick 02.15.2012
		$("gimmExit").stopObserving("click");
		$("gimmExit").observe("click", function(){
			deleteAllMediaInServerInstallationDirectory();
			goToModule("/GIISUserController?action=goToMarketing", "Marketing Main");
		});
	}
	$("quoteDynamicDiv").innerHTML = "";
}