function showAcGroupedItemsList(objArr) {
	try {
		var itemTable = $("acGroupedItemsListing");
		objArr = objArr.filter(function(obj){return nvl(obj.recordStatus, 0) != -1;});
		for(var i=0; i<objArr.length; i++) {
			var content = prepareAcGroupedItemInfo(objArr[i]);
			var newDiv = new Element("div");

			newDiv.setAttribute("id", "grpRow"+objArr[i].itemNo+objArr[i].groupedItemNo);
			newDiv.setAttribute("name", "grpRow");
			newDiv.setAttribute("item", objArr[i].itemNo);
			newDiv.addClassName("tableRow");
			newDiv.setStyle({fontSize: '10px'});	

			newDiv.update(content);
			itemTable.insert({bottom : newDiv});	
			loadRowMouseOverMouseOutObserver(newDiv);

			clickACGrouped(objArr[i], newDiv);
		}
		checkIfToResizeTable("acGroupedItemsListing", "grpRow");
		checkTableIfEmpty("grpRow", "accidentGroupedItemsTable");
	} catch(e) {
		showErrorMessage("showAcGroupedItemsList", e);
	}
}