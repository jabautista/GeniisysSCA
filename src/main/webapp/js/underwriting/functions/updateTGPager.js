/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	08.17.2011	mark jm			update the pager div of the table grid
 * 								Parameters	: tableGrid - name of the table grid to update
 */
function updateTGPager(tableGrid){
	try{
		var deletedVisibleRow = 0;
		
		if(tableGrid != null || tableGrid != undefined){			
			deletedVisibleRow = ((tableGrid.bodyTable.down('tbody').childElements()).filter(function(row){ return row.style.display == "none"; })).length;			
			if(deletedVisibleRow > 0 && tableGrid.pager.total < 1){
				if(nvl($("mtgPagerMsg"+ tableGrid.getId()), false)){
					$("mtgPagerMsg"+ tableGrid.getId()).update(tableGrid._messages.pagerNoDataFound);
				}				
				$$("#pagerDiv" + tableGrid.getId() + " .mtgPagerTable").invoke("hide");
			}else{
				$$("#pagerDiv" + tableGrid.getId() + " .mtgPagerTable").invoke("show");
			}
		}
	}catch(e){
		showErrorMessage("updateTGPager", e);
	}
}