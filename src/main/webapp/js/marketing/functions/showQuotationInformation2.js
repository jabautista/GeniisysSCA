/**
 * @author rey
 * @date 07-14-2011
 * @returns {Boolean}
 * for Quotation Information
 * 
 */
function showQuotationInformation2() {
	var quoteId = 0;
	try{
		//resetQuoteInfoGlobals();
		//quoteId = getSelectedQuotationRowQuoteId();
		//quoteId = $("quoteId") == null || $("quoteId") == undefined ? getSelectedQuotationRowQuoteId() : $F("quoteId");
		//quoteId = $("quotationTableGridListingDiv") == null || $("quotationTableGridListingDiv") == undefined ?  $F("quoteId") : getSelectedQuotationRowQuoteId2(); // <== mark jm 04.14.2011 @UCPBGEN added condition
		quoteId = $F("quoteId"); 
	}catch (e) {
		showErrorMessage("showQuotationInformation2()", e);
	}	
	if (quoteId == 0 && (typeof errorMessage) != undefined) {
		showQuotationListing2Error("There is no quotation selected.");
		return false;
	} else {
		var userId = getUserIdParameterFromTableGrid2();
		selectedQuoteListingIndex2 = -1; // mark jm 04.25.2011 @UCPBGEN
		objGIPIQuote.quoteId = 0; // mark jm 04.25.2011 @UCPBGEN
		//new Ajax.Updater("mainContents", contextPath + "/GIPIQuotationInformationController?action=showQuoteInformationPage&userId=" + userId,
		new Ajax.Updater("mainContents", contextPath + "/GIPIQuoteController?action=showQuoteInformationPage&userId=" + userId,
		{	method : "GET",
			parameters : {
				quoteId : quoteId,
				lineCd: getLineCdMarketing(),
				ajax : "1"
			},
			evalScripts : true,
			asynchronous : true,
			onCreate : function(){ 
				showNotice("Getting quotation information, please wait...");
				resetQuoteInfoGlobals();
			},
			onComplete : function(){
				hideNotice("");
				Effect.Appear("quotationInformationMainDiv", {
					duration : .001
				});
				setDocumentTitle("Quotation Information");
				//$("quotationMenus").show();					
				//$("marketingMainMenu").hide();
				initializeMenu(); // andrew - 03.03.2011 - to fix menu problem
				addStyleToInputs();
				initializeAll();
			}
		});
	}
}