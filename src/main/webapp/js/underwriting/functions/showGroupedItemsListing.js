/*	Created by	: mark jm 03.11.2011
 * 	Description	: set the listing on grouped items listing
 */
function showGroupedItemsListing(){
	try{
		var table = $("groupedItemListing");
		var content = "";
		
		for(var i=0, length=objGIPIWGroupedItems.length; i < length; i++){
			content = prepareGroupedItems(objGIPIWGroupedItems[i]);
			
			var newDiv = new Element("div");
			
			newDiv.setAttribute("id", "rowGroupedItem" + objGIPIWGroupedItems[i].itemNo + "_" + objGIPIWGroupedItems[i].groupedItemNo);
			newDiv.setAttribute("name", "rowGroupedItem");
			newDiv.setAttribute("item", objGIPIWGroupedItems[i].itemNo);
			newDiv.setAttribute("groupedItemNo", objGIPIWGroupedItems[i].groupedItemNo);				
			newDiv.addClassName("tableRow");

			newDiv.update(content);

			table.insert({bottom : newDiv});
			
			loadGroupedItemsRowObserver(newDiv);			
		}
		
		checkPopupsTableWithTotalAmountbyObject(objGIPIWGroupedItems, "groupedItemsTable", "groupedItemListing",
				"rowGroupedItem", "amountCovered", "groupedItemTotalAmountDiv", "groupedItemTotalAmount");
	}catch(e){
		showErrorMessage("showGroupedItemsListing", e);
	}
}