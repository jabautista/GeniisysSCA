//belle 02.16.2012
function checkBeneficiaryChanges(){
	try{
		if (nvl(beneficiaryGrid,null) instanceof MyTableGrid){
			if (beneficiaryGrid.getModifiedRows().length != 0 || beneficiaryGrid.getNewRowsAdded().length != 0 || beneficiaryGrid.getDeletedRows().length != 0){
				return true;
			}
		}
		return false;
	}catch(e){
		showErrorMessage("checkBeneficiaryChanges", e);
	}
	return false;
}