//belle 02.14.2012
function clearClmItemBenForm(){
	try{
		if (nvl(beneficiaryGrid,null) instanceof MyTableGrid) populateBeneficiary(null);
		objCLMItem.newBeneficiary	= [];
		objCLMItem.selBenIndex	= null;
		observeClmItemChangeTag();
		if (nvl(beneficiaryGrid,null) instanceof MyTableGrid) beneficiaryGrid.unselectRows();
	}catch(e){
		showErrorMessage("clearClmItemBenForm", e);
	}
}