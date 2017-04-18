/**
 * Computes the total deductible amount of the selected item
 * @return totalDedAmount - the computed total deductible amount
 */

function computeTotalDeductibleAmountForPackageQuotation(){
	var selectedItemRow = getSelectedRow("row");
	var totalDedAmount = 0;
	
	for(var i=0; i<objPackQuoteDeductiblesList.length; i++){
		if(objPackQuoteDeductiblesList[i].quoteId == objCurrPackQuote.quoteId &&
		   objPackQuoteDeductiblesList[i].itemNo == selectedItemRow.getAttribute("itemNo") &&
		   objPackQuoteDeductiblesList[i].recordStatus != -1){
		   totalDedAmount = parseFloat(totalDedAmount) + parseFloat(nvl(objPackQuoteDeductiblesList[i].deductibleAmt, 0));
		}
	}
	
	totalDedAmount = formatCurrency(totalDedAmount);
	return totalDedAmount; 
}