/**
 * @author rey
 * @date 03-22-2012
 */
function deletePersonnel(){
	personnelGrid.deleteRow(objCLMItem.selPersonnelIndex);
	if (personnelGrid.getModifiedRows().length == 0 && personnelGrid.getNewRowsAdded().length == 0 && personnelGrid.getDeletedRows().length == 0){
	}else{
		changeTag = 1;
	}
	
	enableSearch("perNoDate");
	
	clearPersonnelDetails();
	
	$("btnAddPer").addClassName("disabledButton");
	$("btnAddPer").disabled = true;
}