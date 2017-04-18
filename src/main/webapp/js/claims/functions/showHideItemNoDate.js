/* belle 01.20.2012
** show/hide search button fot item no/ grouped item no 
** allow one item only except for line FI
*/
function showHideItemNoDate(){
	if (objCLMGlobal.lineCd != objLineCds.FI || objCLMGlobal.menuLineCd != objLineCds.FI){
		if (objCLMItem.objItemTableGrid.rows.length != 0 || itemGrid.getNewRowsAdded().length != 0){
			$("itemNoDate").hide();
			if ($("grpItemNo")) $("grpItemNo").hide();
			$("txtItemNo").readOnly = true;
			if ($("txtGrpItemNo")) $("txtGrpItemNo").readOnly = true;
			disableButton("btnAddItem");
			if (objCLMGlobal.lineCd == objLineCds.AC || objCLMGlobal.menuLineCd == objLineCds.AC){
				$("grpItemNo").hide();
				$("txtItemNo").readOnly = true;
				$("txtGrpItemNo").readOnly = true;
			}
			
		}else{
			$("itemNoDate").show();
			if ($("grpItemNo")) $("grpItemNo").show();
			enableButton("btnAddItem");
			if (objCLMGlobal.lineCd == objLineCds.AC || objCLMGlobal.menuLineCd == objLineCds.AC){
				$("grpItemNo").show();
			}
		}
	}	
}