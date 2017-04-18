/**
 * Build listing of Quote items Peril from a JSON Array 
 * containing quote items peril information
 * @param objArray - JSON Array
 */

function showQuoteItemPerilList(objArray){
	try {
		var quoteItemPerilTable = $("quoteItemPerilTableContainer");
		
		objArray = objArray.filter(function(obj){ return nvl(obj.recordStatus, 0) != -1; });
		
		for(var i=0; i<objArray.length; i++) {			
			var newDiv = createQuoteItemPerilRow(objArray[i]);
			quoteItemPerilTable.insert({bottom : newDiv});
			newDiv.setStyle("display : none;");
			setQuoteItemPerilRowObserver(newDiv);
		}
		
		checkIfToResizeTable("quoteItemPerilTableContainer", "perilRow");
		checkTableIfEmpty("perilRow", "itemPerilTable");
		
		if(objMKGlobal.packQuoteId != null){
			resizeTableBasedOnVisibleRows("itemPerilTable", "quoteItemPerilTableContainer");
			$("itemPerilTable").hide();
		}
		
	} catch (e) {
		showErrorMessage("showQuoteItemPerilList", e);
	}
}