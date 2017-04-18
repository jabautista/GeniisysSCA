/**
 * 
 * @return
 */
function showQuotationCarrierInfoPage() {
	try {
		// comment out by andrew - 02.10.2012
		//var quoteId = $("quotationTableGridSectionDiv") == null || $("quotationTableGridSectionDiv") == undefined ?  $F("quoteId") : getSelectedQuotationRowQuoteId(); // <== mark jm 04.14.2011 @UCPBGEN added condition
		
		if(objGIPIQuote != null) { // andrew - 02.10.2012
			quoteId = objGIPIQuote.quoteId;
		}
		
		if (quoteId == 0 && (typeof errorMessage) != undefined) {
			showQuotationListingError("Please select a quotation.");
			return false;
		} else {
			carrierInfoExitCtr = 1;//patrick for carrier exit counter
			//selectedQuoteListingIndex = -1; // mark jm 04.25.2011 @UCPBGEN // comment out by andrew - 01.17.2012 - causing problem when going to other modules from carrier info page 
			//objGIPIQuote.quoteId = 0; // mark jm 04.25.2011 @UCPBGEN // comment out by andrew - 01.17.2012 - causing problem when going to other modules from carrier info page
			//new Ajax.Updater("mainContents","GIPIQuoteVesAirController?action=showQuoteVesAirPage", {  // andrew - 02.10.2012
			new Ajax.Updater("quoteInfoDiv","GIPIQuoteVesAirController?action=showQuoteVesAirPageTableGrid&ajax=1", { //steven 3.15.2012
				method : "GET",
				parameters : {
					quoteId : quoteId
				},
				evalScripts : true,
				asynchronous : true,
				onCreate : function() {
					Effect.Fade($("mainContents").down("div", 0),
					{	duration : .001,
						afterFinish : function() {
							showNotice("Getting carrier information, please wait...");
						}
					});
				},
				onComplete : function() {
					hideNotice();
					$("quoteListingMainDiv").hide(); // andrew - 02.09.2012
					$("quoteInfoDiv").show();
					Effect.Appear("carrierInfoMainDiv", {
						duration : .001
					});
				}
			});
		}
	} catch(e){
		showErrorMessage("showQuotationCarrierInfoPage", e);
	}
}