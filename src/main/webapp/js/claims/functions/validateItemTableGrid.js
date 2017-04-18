/**
 * @author rey
 * @date 04.24.2012
 */
function validateItemTableGrid(){
	try{
		if (objCLMGlobal.lineCd == objLineCds.CA || objCLMGlobal.menuLineCd == objLineCds.CA){
			if (itemGrid.rows.length != 0 || itemGrid.getNewRowsAdded().length != 0){
				$("itemNoDate").hide();
				$("groupNoDate").hide();
				$("txtItemNo").setAttribute("readonly", "readonly");
				$("txtGrpCd").setAttribute("readonly", "readonly");
				
				disableButton("btnAddItem");
			}else{
				$("itemNoDate").show();
				$("groupNoDate").show();
				enableButton("btnAddItem");
			}				
		}
		if (objCLMGlobal.lineCd != objLineCds.FI || objCLMGlobal.menuLineCd != objLineCds.FI){
			if (itemGrid.rows.length != 0 || itemGrid.getNewRowsAdded().length != 0){
				$("itemNoDate").hide();
				$("txtItemNo").setAttribute("readonly", "readonly");
				disableButton("btnAddItem");
			}else{
				$("itemNoDate").show();
				enableButton("btnAddItem");
			}				
		}
	}
	catch(e){
		showErrorMessage("validateItemTableGrid",e);
	}
}