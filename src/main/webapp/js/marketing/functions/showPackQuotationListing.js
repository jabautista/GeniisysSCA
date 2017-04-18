/**
 * Shows the package quotation listing
 * @author andrew robes
 * @date 02.09.2012
 */
function showPackQuotationListing(){						
	enggBasicInfoExitCtr = 0;
	carrierInfoExitCtr = 0;
	assuredMaintainGimmExitCtr = 0;
	$("quoteListingMainDiv").show();
	$("quoteInfoDiv").innerHTML = "";
	objGIPIQuote.quoteId = 0;
	objMKGlobal.quoteId = 0;
	packQuotationTableGrid.refresh();
	setDocumentTitle("Pack Quotation Listing");
	
	$("gimmExit").stopObserving("click");
	$("gimmExit").observe("click", function(){
		deleteAllMediaInServerInstallationDirectory();
		goToModule("/GIISUserController?action=goToMarketing", "Marketing Main");
	});
}