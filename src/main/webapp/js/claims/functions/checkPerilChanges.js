/**
 * Check if changes exists in peril module
 * 
 * @author Niknok Orio
 * @param
 * @return true if changes exists else false
 */
function checkPerilChanges(){
	try{
		if (nvl(perilGrid,null) instanceof MyTableGrid){
			if (perilGrid.getModifiedRows().length != 0 || perilGrid.getNewRowsAdded().length != 0 || perilGrid.getDeletedRows().length != 0){
				return true;
			}
		}
		return false;
	}catch(e){
		showErrorMessage("checkPerilChanges", e);
	}
	return false;
}