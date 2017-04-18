//belle 12.20.2011
function observeClmGrpItemNoBlur(){
	try{
		$("txtGrpItemNo").observe("blur", function(){ 
			if($F("txtItemNo") != ""){
				if (checkClmItemChanges(true)){
					if (($F("txtGrpItemNo") != "" && checkIfValueChanged("txtGrpItemNo")) || (objCLMItem.grpItemLovSw && $F("txtGrpItemNo") != "")){
						validateClmItemNo();
					}
				}
				objCLMItem.grpItemLovSw = false;
			} else {
				showMessageBox("Please select an Item No. first.", imgMessage.INFO);
				$("txtItemNo").focus();
				$("txtGrpItemNo").clear();
			}
		});
	}catch(e){
		showErroMessage("observeClmGrpItemNoBlur", e);
	}
}