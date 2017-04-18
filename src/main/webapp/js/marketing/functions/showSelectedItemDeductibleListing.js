/**
 * Shows deductible listing of a selected item
 * @author Veronica V. Raymundo
 * @return
 */
function showSelectedItemDeductibleListing(){
	var selectedItemNo = getSelectedRowId("itemRow");
	$("deductibleListing").update("");
	for(var i=0; i<objGIPIQuoteDeductiblesSummaryList.length; i++){
		if(objGIPIQuoteDeductiblesSummaryList[i].itemNo == selectedItemNo && objGIPIQuoteDeductiblesSummaryList[i].recordStatus != -1){
			var deductibleRow = makeGIPIQuoteDeductibleRow(objGIPIQuoteDeductiblesSummaryList[i]);
			$("deductibleListing").insert({ bottom: deductibleRow});
		}
	}
	resetTableStyle("deductiblesTable", "deductibleListing", "deductibleRow");
	computeTotalDeductibleAmount();
}