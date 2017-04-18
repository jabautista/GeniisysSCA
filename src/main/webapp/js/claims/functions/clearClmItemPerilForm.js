/**
 * Clear form & objects for item peril
 * 
 * @author Niknok Orio
 * @param
 */
function clearClmItemPerilForm(){
	try{
		if (nvl(perilGrid,null) instanceof MyTableGrid) supplyClmItemPeril(null);
		objCLMItem.selectedPeril  	= {};
		objCLMItem.newPeril			= [];
		objCLMItem.selPerilIndex 	= null;
		objCLMItem.perilCd			= null;
		objCLMItem.lossCatCd		= null;
		objCLMItem.deletePerilSw	= false;
		observeClmItemChangeTag(); 
		if (nvl(perilGrid,null) instanceof MyTableGrid) perilGrid.unselectRows();
	}catch(e){
		showErrorMessage("clearClmItemPerilForm", e);
	}
}