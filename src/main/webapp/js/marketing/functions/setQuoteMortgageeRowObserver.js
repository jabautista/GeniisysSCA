/**
 * Sets observer for Package Quote Mortgagee listing row
 * @param row - row to be observe
 */

function setQuoteMortgageeRowObserver(row){
	
	loadRowMouseOverMouseOutObserver(row);
	
	row.observe("click", function(){
		row.toggleClassName("selectedRow");
		($$("div#quoteMortgageeTable div:not([id='" + row.id + "'])")).invoke("removeClassName", "selectedRow");
		if (row.hasClassName("selectedRow")){
			var mortgagee = objPackQuoteMortgageeList; 
			for(var i=0; i<mortgagee.length; i++){
				if(mortgagee[i].quoteId == row.getAttribute("quoteId") &&
				   mortgagee[i].itemNo == row.getAttribute("itemNo") && 
				   mortgagee[i].mortgCd == row.getAttribute("mortgCd")){
					setQuoteMortgageeInfoForm(mortgagee[i]);
				}
			}
		}else{
			setQuoteMortgageeInfoForm(null);
		}
	});
}