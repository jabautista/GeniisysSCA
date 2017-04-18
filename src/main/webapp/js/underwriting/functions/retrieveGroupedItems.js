/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	09.13.2011	mark jm			show grouped items records
 * 								Parameters	: no more explanation :D 
 */
function retrieveGroupedItems(parId, itemNo){
	try{		
		new Ajax.Updater("groupedItemsTable", contextPath+"/GIPIWGroupedItemsController?action=getGIPIWGroupedItemsTableGrid&parId="+parId+"&itemNo="+itemNo, {
			method: "GET",
			asynchronous: false,
			evalScripts: true,
			onCreate: function(){
				$("groupedItemsTable").hide();
			},
			onComplete: function(){
				$("groupedItemsTable").show();				
			}
		});
	}catch(e){
		showErrorMessage("retrieveGroupedItems", e);
	}
}