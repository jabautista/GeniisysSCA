/**
 * Display Quotation Bond Policy Data (GIIMM011)
 * @author Jerome Orio 03.07.2011
 * @version 1.0
 * @return
 */
function showBondPolicyData(paramQuoteId){ // added parameter paramQuoteId - andrew - 01.09.2012
	var quoteId = "";
	
	if(objGIPIQuote != null) { // andrew - 02.10.2012
		quoteId = objGIPIQuote.quoteId;
	} else if(paramQuoteId){
		quoteId = paramQuoteId;
	} else {
		quoteId = $("quotationTableGridSectionDiv") == null || $("quotationTableGridSectionDiv") == undefined ?  $F("quoteId") : getSelectedQuotationRowQuoteId(); // <== mark jm 04.14.2011 @UCPBGEN added condition
	}
	
	if (quoteId == 0/* && (typeof errorMessage) != undefined*/) {
		showQuotationListingError("There is no quotation selected.");
		return false;
	} else {
		var userId = getUserIdParameterFromTableGrid();
		selectedQuoteListingIndex = -1; // mark jm 04.25.2011 @UCPBGEN
		objGIPIQuote.quoteId = 0; // mark jm 04.25.2011 @UCPBGEN
		//new Ajax.Updater("mainContents", contextPath + "/GIPIQuotationBondBasicController?action=showQuoteBondPolicyData&userId=" + userId,{
		new Ajax.Updater("quoteInfoDiv", contextPath + "/GIPIQuotationBondBasicController?action=showQuoteBondPolicyData&userId=" + userId,{
			method : "GET",
			parameters : {
				quoteId : quoteId
				//ajax :	 "1",
				//lineCd : lineCd
			},
			asynchronous : false,
			evalScripts : true,
			onCreate : showNotice("Getting bond policy data, please wait..."),
			onComplete : function() {
				$("quoteListingMainDiv").hide(); // andrew - 02.10.2012
				$("quoteInfoDiv").show();
				Effect.Appear("quotationBondPolicyMainDiv", {
					duration : .001
				});
				$("quotationMenus").show();			
				$("marketingMainMenu").hide();
				initializeMenu();
			}
		});
	}
}