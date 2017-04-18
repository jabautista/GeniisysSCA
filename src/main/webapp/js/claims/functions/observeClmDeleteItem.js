/**
 * Create observe on delete item button
 * 
 * @author Niknok Orio
 * @param
 */
function observeClmDeleteItem(){
	try{
		$("btnDeleteItem").observe("click", function(){
			if (nvl(objCLMItem.selItemIndex,null) != null){
				var msg = unescapeHTML2(objCLMItem.selected[itemGrid.getColumnIndex('giclItemPerilMsg')]);
				if (msg == "3"){
					showMessageBox("Cannot delete this record. Corresponding loss/expense reserve was already set up.", "I");
					return false;
				}else if(msg == "2"){
					showConfirmBox("Confirmation", "Are you sure you want to delete this record?", 
							"Yes", "No", function(){deleteClmItem();}, "");
					return false;
				}else if(msg == "1"){
					if (objCLMGlobal.lineCd == objLineCds.AC || objCLMGlobal.menuLineCd == objLineCds.AC){ 
						showConfirmBox("Confirmation", "Corresponding peril and beneficiary  record(s) will be deleted. Continue?", 
								"Yes", "No", function(){deleteClmItem();}, ""); //belle 02.13.2012
						return false; 
					}else{
						showConfirmBox("Confirmation", "Corresponding peril record(s) will be deleted. Continue?", 
								"Yes", "No", function(){deleteClmItem();}, "");
						return false;
					}
					
				}  
			}
		});
	}catch(e){
		showErrorMessage("observeClmDeleteItem" ,e);
	}
}