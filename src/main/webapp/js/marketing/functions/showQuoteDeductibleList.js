/**
 * Build listing of Quote Deductibles from a JSON Array 
 * containing quote deductible information
 * @param objArray - JSON Array
 */

function showQuoteDeductibleList(objArray){
	try {
		var quoteDeductibleTable = $("quoteDeductibleTableContainer");
		
		objArray = objArray.filter(function(obj){ return nvl(obj.recordStatus, 0) != -1; });
		
		for(var i=0; i<objArray.length; i++) {			
			var newDiv = createQuoteDeductibleRow(objArray[i]);
			quoteDeductibleTable.insert({bottom : newDiv});
			newDiv.setStyle("display : none;");
			setQuoteDeductibleRowObserver(newDiv);
		}
		
		checkIfToResizeTable("quoteDeductibleTableContainer", "deductibleRow");
		checkTableIfEmpty("deductibleRow", "quoteDeductiblesTable");
		
		if(objMKGlobal.packQuoteId != null){
			resizeTableBasedOnVisibleRowsWithTotalAmount("quoteDeductiblesTable", "quoteDeductibleTableContainer");
			$("quoteDeductiblesTable").hide();
		}
		
	} catch (e) {
		showErrorMessage("showQuoteDeductibleList", e);
	}
}