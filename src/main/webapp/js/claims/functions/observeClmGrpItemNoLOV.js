//belle 12.05.2011
function observeClmGrpItemNoLOV(){
	try{
		$("grpItemNo").observe("click", function(){
			if($F("txtItemNo") != ""){
				if (objCLMItem.selected != {} || objCLMItem.selected != null) if (unescapeHTML2(objCLMItem.selected[itemGrid.getColumnIndex('giclItemPerilExist')]) == "Y") return;
				showClmGrpItemNoLOV();
			} else {
				showMessageBox("Please select an Item No. first.", imgMessage.INFO);
				$("txtItemNo").focus();
				$("txtGrpItemNo").clear();
			}
		});
		
	}catch(e){
		showErrorMessage("observeClmGrpItemNoLOV", e);
	}
}