/* JSONObjects BJGA 12.29.2010 */
var objGIPIQuote = new Object();
	objGIPIQuote.quoteId = 0;
var objGIPIQuoteItemList = null;

var objGIPIQuoteItemPerilSummaryList = null;
var objGIPIQuoteMortgageeList = null;
var objGIPIQuoteInvoiceList = null;

// JSON LOVs - start for item
var objItemCurrencyLov = null;
var objItemCoverageLov = null;
// for selPeril - visible
var objItemPerilLov = null; // in quotationInformationMain/perilInformaton.jsp for selDeductibles - hidden
var objItemPerilDeductibleLov = null;// deductibles in perils -- not the GIPIQuoteDeductibles
var objMortgageeLov = null;
// JSON LOVs - END

// defaultValues
var defCurrencyCd;

/*
 * quoteId; itemNo; itemTitle; itemDesc; currencyCd; currencyDesc; currencyRate;
 * coverageCd; coverageDesc; perilCd; perilName; perilType; basicPerilCd;
 * premiumRate; tsiAmount; premiumAmount; annPremAmt; compRem; wcSw;
 */

//var perilNameChanged = false;
var attachWc = false;

/**
 * @deprecated
 */
function areSimilarPerilObjects(perilObj1, perilObj2){
	if(perilObj1.perilCd == perilObj2.perilCd){
		return true;
	}
	return false;
}

/**
 * @unused
 * @return
 */
function makeAttachedMediaRow(mediaObj){
	var mediaRow =  new Element("div");
	mediaRow.setAttribute("id", "");
	mediaRow.setAttribute("name", "mediaRow");
	mediaRow.setAttribute("itemNo", mediaObj.itemNo);
}