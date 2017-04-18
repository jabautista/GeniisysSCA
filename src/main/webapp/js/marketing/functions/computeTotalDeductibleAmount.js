/**
 * Computes total deductible amount in quotationInformationMain/deductibleInformation(accordion)
 * @author rencela
 */
function computeTotalDeductibleAmount(){
	var total = 0.00;
	var selectedItemNo = getSelectedRowId("itemRow");
		
	for(var i=0; i<objGIPIQuoteDeductiblesSummaryList.length; i++){
		if(objGIPIQuoteDeductiblesSummaryList[i].recordStatus != -1 && objGIPIQuoteDeductiblesSummaryList[i].itemNo == selectedItemNo){
			total = parseFloat(total) + parseFloat(nvl(objGIPIQuoteDeductiblesSummaryList[i].deductibleAmt, 0));
		}
	}
	$("totalDeductibleAmount").innerHTML = formatCurrency(total);
	/* FORCE MARINEHULL AI TO APPEAR?
	if ("MC" == objGIPIQuote.lineCd){ //added to display deductible total amount on deductible field in additional itemInfo BRY 01.03.2011
		if ($("additionalInformationDiv") != undefined){
			$("deductibles").value = formatCurrency(total);
		}
	}
	*/
}