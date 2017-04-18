/**
 * Sets observer for Package Quote Item Peril listing row
 * @param row - row to be observe
 */

function setQuoteItemPerilRowObserver(row){
	
	loadRowMouseOverMouseOutObserver(row);
	
	row.observe("click", function(){
		row.toggleClassName("selectedRow");
		if (row.hasClassName("selectedRow")){				
			($$("div#itemPerilTable div:not([id='" + row.id + "'])")).invoke("removeClassName", "selectedRow");
			var perils = objPackQuoteItemPerilList; 
			for(var i=0; i<perils.length; i++){
				if(perils[i].quoteId == row.getAttribute("quoteId") &&
				   perils[i].itemNo == row.getAttribute("itemNo") &&
				   perils[i].perilCd == row.getAttribute("perilCd")){
					setQuoteItemPerilInfoForm(perils[i]);
				}
			}
		}else{
			setQuoteItemPerilInfoForm(null);
		}
	});
}