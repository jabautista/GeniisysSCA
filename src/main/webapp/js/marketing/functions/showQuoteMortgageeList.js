/**
* Build listing of Quote Mortgagee from a JSON Array 
* containing quote mortgagee information
* @param objArray - JSON Array
*/

function showQuoteMortgageeList(objArray){
	try {
		var quoteMortgageeTable = $("quoteMortgageeTableContainer");
		
		objArray = objArray.filter(function(obj){ return nvl(obj.recordStatus, 0) != -1 && obj.itemNo != 0; });
		
		for(var i=0; i<objArray.length; i++) {			
			var newDiv = createQuoteMortgageeRow(objArray[i]);
			quoteMortgageeTable.insert({bottom : newDiv});
			setQuoteMortgageeRowObserver(newDiv);
		}
		
		checkIfToResizeTable("quoteMortgageeTableContainer", "mortgageeRow");
		checkTableIfEmpty("mortgageeRow", "quoteMortgageeTable");
		
		if(objMKGlobal.packQuoteId != null){
			var selectedItem = getSelectedRow("row");
			($$("div#quoteMortgageeTableContainer div:not([quoteId='" + selectedItem.getAttribute("quoteId") + "'])")).invoke("hide");
			($$("div#quoteMortgageeTableContainer div:not([itemNo='" + selectedItem.getAttribute("itemNo") + "'])")).invoke("hide");
			resizeTableBasedOnVisibleRows("quoteMortgageeTable", "quoteMortgageeTableContainer");
			$("txtMortgageeItemNo").value 	= $("txtItemNo").value;
		}
		
	} catch (e) {
		showErrorMessage("showQuoteMortgageeList", e);
	}
}