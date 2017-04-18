/**
 * Observe change tag on item info
 * 
 * @author Niknok Orio
 * @param
 */
function observeClmItemChangeTag(){
	try{
		if (nvl(itemGrid,null) instanceof MyTableGrid) observeChangeTagInTableGrid(itemGrid);
		if (nvl(perilGrid,null) instanceof MyTableGrid) observeChangeTagInTableGrid(perilGrid);
		if (nvl(beneficiaryGrid,null) instanceof MyTableGrid) observeChangeTagInTableGrid(beneficiaryGrid); 
		if (nvl(itemGrid,null) instanceof MyTableGrid){
			if (itemGrid.getModifiedRows().length == 0 && itemGrid.getNewRowsAdded().length == 0 && itemGrid.getDeletedRows().length == 0){
				if (nvl(perilGrid,null) instanceof MyTableGrid){
					if (perilGrid.getModifiedRows().length == 0 && perilGrid.getNewRowsAdded().length == 0 && perilGrid.getDeletedRows().length == 0){
						changeTag = 0;
					}	
				}else if (nvl(beneficiaryGrid,null) instanceof MyTableGrid){ 
					if (beneficiaryGrid.getModifiedRows().length == 0 && beneficiaryGrid.getNewRowsAdded().length == 0 && beneficiaryGrid.getDeletedRows().length == 0){
						changeTag = 0;
					}
				}else{
					changeTag = 0;
				} 
			}
		}
	}catch(e){
		showErrorMessage("observeClmItemChangeTag" ,e);
	}
}