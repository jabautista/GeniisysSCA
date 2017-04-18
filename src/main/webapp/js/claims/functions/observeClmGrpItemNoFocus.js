//belle 12.20.2011
function observeClmGrpItemNoFocus(){
	try{
		initPreTextOnField("txtGrpItemNo");
		$("txtGrpItemNo").observe("focus", function(){
			if (objCLMItem.grpItemLovSw){
				$("txtGrpItemNo").blur();
			}
		});
	}catch(e){
		showErrorMessage("observeClmGrpItemNoFocus", e);
	}	
}