function clearTableGridDetails(tableGrid){
	try{		
		if(tableGrid != null || tableGrid != undefined){
			tableGrid.empty();
			
			if(nvl($("mtgPagerMsg"+ tableGrid.getId()), false)){
				$("mtgPagerMsg"+ tableGrid.getId()).update(tableGrid._messages.pagerNoDataFound);
			}
			
			$$("#pagerDiv" + tableGrid.getId() + " .mtgPagerTable").invoke("hide");
		}
	}catch(e){
		showErrorMessage("hideTableGridDetails", e);
	}
}