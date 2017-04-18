/**
 * Save claim item info
 * 
 * @author Niknok Orio
 * @param postSaving -
 *            if true, postSave function will call after saving
 */
function saveClaimsItemGrid(postSaving){
	try{
		itemGrid._blurCellElement(itemGrid.keys._nCurrentFocus==null?itemGrid.keys._nOldFocus:itemGrid.keys._nCurrentFocus);             
		if (nvl(perilGrid,null) instanceof MyTableGrid) perilGrid._blurCellElement(perilGrid.keys._nCurrentFocus==null?perilGrid.keys._nOldFocus:perilGrid.keys._nCurrentFocus);  
		if (!itemGrid.preCommit()){ return false; }
		if (nvl(perilGrid,null) instanceof MyTableGrid){ if (!perilGrid.preCommit()){ return false; }}
		var ok = true;
		if (itemGrid.options.toolbar.onSave) {
			ok = itemGrid.options.toolbar.onSave.call();
		}
		if ((ok || ok==undefined)){
			itemGrid.releaseKeys();
			if (nvl(perilGrid,null) instanceof MyTableGrid){
				perilGrid.releaseKeys();
			}
			if (nvl(postSaving,false)){
				if (itemGrid.options.toolbar.postSave) {
					itemGrid.options.toolbar.postSave.call();
		    	}
			}
		}
		
	}catch (e) {
		showErrorMessage("saveClaimsItemGrid" ,e);
	}
}