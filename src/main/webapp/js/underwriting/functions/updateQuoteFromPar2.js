/**
 * Another version of updateQuoteFromPar, using the selected row from lov
 * @author andrew
 * @date 05.06.2011
 * @param row - selected row from lov
 */
function updateQuoteFromPar2(row){
	$("fromQuote").value = "Y";
	saveCreatedPAR2(row);
	prepareParFromQuote2(row);
}