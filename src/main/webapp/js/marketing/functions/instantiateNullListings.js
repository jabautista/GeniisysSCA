/**
 * Sets null lists to new Array() to prevent errors in saving
 * @author rencela
 * @return
 */
function instantiateNullListings(){
//	objGIPIQuote = new Object();
//	objGIPIQuote.quoteId = 0;
	if(objGIPIQuoteItemList==null){
		objGIPIQuoteItemList = new Array();
	}
	if(objGIPIQuoteItemPerilSummaryList==null){
		objGIPIQuoteItemPerilSummaryList = new Array();
	}
	if(objGIPIQuoteMortgageeList==null){
		objGIPIQuoteMortgageeList = new Array();
	}
	if(objGIPIQuoteInvoiceList==null){
		objGIPIQuoteInvoiceList = new Array();
	}

	if(objGIPIQuoteDeductiblesSummaryList==null){
		objGIPIQuoteDeductiblesSummaryList = new Array();
	}
}