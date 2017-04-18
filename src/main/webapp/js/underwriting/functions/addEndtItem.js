/**
 * Add item to be endorsed selected from add/delete items button
 * @author andrew
 * @date 05.14.2011
 * @param newObj
 */
function addEndtItem(newObj) {
	try {
		var lineCd = getLineCd();	
		content = prepareEndtItemInfo(newObj);
		
		prepareEndtItemByLine(newObj);
		objGIPIWItem.push(newObj);
			
		var itemTable = $("parItemTableContainer");
		var newDiv = new Element("div");
		newDiv.setAttribute("id", "row"+newObj.itemNo);
		newDiv.writeAttribute("new");
		newDiv.setAttribute("name", "row");
		newDiv.setAttribute("item", newObj.itemNo);
		newDiv.setStyle("display: none;");
		newDiv.addClassName("tableRow");
		
		newDiv.update(content);
		itemTable.insert({bottom : newDiv});
		
		loadRowMouseOverMouseOutObserver(newDiv);
						
		newDiv.observe("click", function() {
			clickParItemRow(newDiv, getItemObjects());
		});
		
		objItemNoList.push({"itemNo" : newObj.itemNo});
		
		checkIfToResizeTable("parItemTableContainer", "row");
		checkTableIfEmpty("row", "itemTable");			
		
		new Effect.Appear("row"+newObj.itemNo, {
				duration: 0.2
			});
		
		setParItemForm(null);			
	} catch (e) {
		showErrorMessage("addEndtItem", e);
	}
}