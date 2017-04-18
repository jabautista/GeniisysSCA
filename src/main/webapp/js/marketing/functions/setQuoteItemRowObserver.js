/**
 * Sets observer for Package Quote Item listing row
 * @param row - row to be observe
 */

function setQuoteItemRowObserver(row){
	
	loadRowMouseOverMouseOutObserver(row);
	
	row.observe("click", function(){
		row.toggleClassName("selectedRow");
		resetAllPackQuotationInformationForms();
		if (row.hasClassName("selectedRow")){				
			($$("div#quoteItemTable div:not([id='" + row.id + "'])")).invoke("removeClassName", "selectedRow");
			var items = objPackQuoteItemList; 
			for(var i=0; i<items.length; i++){    
				if( items[i].quoteId == row.getAttribute("quoteId") &&
					items[i].itemNo == row.getAttribute("itemNo")){
					setQuoteItemInfoForm(items[i]);
					showQuoteItemChildRecordDetails(row);
				}
			}
		}else{
			$("itemPerilTable").hide();
		}
		computeTotalItemTsiandPremAmount("txtTotalTsiAmount", "txtTotalPremiumAmount");
		showPackQuoteAccordionHeaders();
	});
}