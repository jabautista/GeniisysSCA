/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	08.16.2011	mark jm			empty/clear table grid records related to deleted item (UI only)
 * 								Parameters : tableGrid - name of the tableGrid
 */
function deleteParItemTG(tableGrid){
	try{		
		if(tableGrid != null || tableGrid != undefined){
			tableGrid.empty();
			
			if(nvl($("mtgPagerMsg"+ tableGrid.getId()), false)){
				$("mtgPagerMsg"+ tableGrid.getId()).update(tableGrid._messages.pagerNoDataFound);
			}
			
			$$("#pagerDiv" + tableGrid.getId() + " .mtgPagerTable").invoke("hide");
		}
	}catch(e){
		showErrorMessage("deleteParItemTG", e);
	}
}