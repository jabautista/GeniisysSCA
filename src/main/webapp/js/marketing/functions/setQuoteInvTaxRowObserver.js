/**
 * Sets observer for Package Quote Invoice Tax listing row
 * @param row - row to be observe
 */

function setQuoteInvTaxRowObserver(row){
	
	loadRowMouseOverMouseOutObserver(row);
	
	row.observe("click", function(){
		row.toggleClassName("selectedRow");
		($$("div#quoteInvTaxTable div:not([id='" + row.id + "'])")).invoke("removeClassName", "selectedRow");
		if (row.hasClassName("selectedRow")){
			var selectedItemRow = getSelectedRow("row");
			var currQuoteInvoice = getCurrPackQuoteInvoice(selectedItemRow);
			var invTax = currQuoteInvoice.invoiceTaxes;
			for(var c=0; c<invTax.length; c++){
				if(invTax[c].taxCd == row.getAttribute("taxCd")){
					setQuoteInvTaxForm(invTax[c]);
					break;
				}
			}
		}else{
			setQuoteInvTaxForm(null);
		}
	});
}