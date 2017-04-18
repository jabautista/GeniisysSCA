/**
 * Sets observer for Package Quote Deductible listing row
 * @param row - row to be observe
 */

function setQuoteDeductibleRowObserver(row){
	
	loadRowMouseOverMouseOutObserver(row);
	
	row.observe("click", function(){
		row.toggleClassName("selectedRow");
		($$("div#quoteDeductiblesTable div:not([id='" + row.id + "'])")).invoke("removeClassName", "selectedRow");
		if (row.hasClassName("selectedRow")){
			var deductibles = objPackQuoteDeductiblesList; 
			for(var i=0; i<deductibles.length; i++){
				if(deductibles[i].quoteId == row.getAttribute("quoteId") &&
				   deductibles[i].itemNo == row.getAttribute("itemNo") && 
				   deductibles[i].dedDeductibleCd == row.getAttribute("deductibleCd")){
					setQuoteDeductibleInfoForm(deductibles[i]);
				}
			}
		}else{
			setQuoteDeductibleInfoForm(null);
		}
	});
}