/**
 * Build listing of Quote items from a JSON Array 
 * containing quote items information
 * @param objArray - JSON Array
 */

function showQuoteItemList(objArray){
	try {
		var quoteItemTable = $("quoteItemTableContainer");
		
		objArray = objArray.filter(function(obj){ return nvl(obj.recordStatus, 0) != -1; });
		
		for(var i=0; i<objArray.length; i++) {			
			var newDiv = createQuoteItemRow(objArray[i]);
			quoteItemTable.insert({bottom : newDiv});
			
			if(objMKGlobal.packQuoteId != null && objCurrPackQuote == null){
				newDiv.setStyle("display : none;");
			}
			
			setQuoteItemRowObserver(newDiv);
		}
		
		checkIfToResizeTable("quoteItemTableContainer", "row");
		checkTableIfEmpty("row", "quoteItemTable");
		
		if(objMKGlobal.packQuoteId != null){
			resizeTableBasedOnVisibleRows("quoteItemTable", "quoteItemTableContainer");
			$("quoteItemTable").hide();
		}
		
	} catch (e) {
		showErrorMessage("showQuoteItemList", e);
	}
}