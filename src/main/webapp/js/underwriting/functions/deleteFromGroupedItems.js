/*	Created by	: mark jm 02.24.2011
 * 	Description	: delete grouped items records on obj list and table list
 * 	Parameters	: itemNo - itemNo to be deleted
 */
function deleteFromGroupedItems(itemNo){
	try{
		$$("div#groupedItemsTable div[item='" + itemNo + "']").each(function(row){
			if(row.hasClassName("selectedRow")){
				fireEvent(row, "click");
			}
			
			Effect.Fade(row, {
				duration : 0.3,
				afterFinish : function(){
					if(objGIPIWGroupedItems != null && (objGIPIWGroupedItems.filter(getRecordsWithSameItemNo)).length > 0){
						var delObj = new Object();

						delObj.parId = (objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId"));
						delObj.itemNo = itemNo;
						delObj.groupedItemNo = row.getAttribute("groupedItemNo");

						addDelObjByAttr(objGIPIWGroupedItems, delObj, "groupedItemNo");

						delete delObj;						
					}
					
					deleteTempCAGrpItms(itemNo); //Deo [01.26.2017]: SR-23702
					
					row.remove();
					checkIfToResizeTable2("groupedItemListing", "rowGroupedItem");
					checkTableIfEmpty2("rowGroupedItem", "groupedItemsTable");
					setGroupedItemsForm(null);
				}
			});
		});
	}catch(e){
		showErrorMessage("deleteFromGroupedItems", e);
	}
}