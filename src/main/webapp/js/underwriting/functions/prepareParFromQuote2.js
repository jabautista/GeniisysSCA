/**
 * Another version of prepareParFromQuote, using the selected row from lov
 * @author andrew
 * @date 05.06.2011
 * @param row - selected record from lov
 */
function prepareParFromQuote2(row){
	$("quoteSeqNo").value = "00";
	$("year").value = $("parYy").value;
	$("quoteId").value = row.quoteId;
}