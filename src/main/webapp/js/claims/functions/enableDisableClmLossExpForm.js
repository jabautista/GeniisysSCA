function enableDisableClmLossExpForm(enableSw){
	$("hrefHistStatus").stopObserving("click");
	$("hrefRemarks").stopObserving("click");
	
	if(enableSw == "enable"){
		$("txtHistSeqNo").readOnly = false;
		$("txtRemarks").readOnly = false;
		$("chkExGratia").enable();
		$("chkFinalTag").enable();
		enableButton("btnAddClmLossExp");
		$("hrefHistStatus").show();
		
		$("hrefRemarks").observe("click", function(){
			if(objCurrGICLItemPeril == null){
				showMessageBox("Please select an item first.", "I");
			}else if(objCurrGICLLossExpPayees == null){
				showMessageBox("Please select a payee first.", "I");
			}else{
				showEditor("txtRemarks", 4000);
			}
		});
		
		$("hrefHistStatus").observe("click", function(){
			if(objCurrGICLItemPeril == null){
				showMessageBox("Please select an item first.", "I");
			}else if(objCurrGICLLossExpPayees == null){
				showMessageBox("Please select a payee first.", "I");
			}else{
				getGiclLeStatLOV();
			}
		});
		
	}else{
		$("txtHistSeqNo").readOnly = true;
		//$("txtRemarks").readOnly = true;
		//$("chkExGratia").disable();     nante 11.5.2013
		//$("chkFinalTag").disable();     nante 11.5.2013
		disableButton("btnAddClmLossExp");
		disableButton("btnDeleteClmLossExp");
		$("hrefHistStatus").hide();
		
		$("hrefRemarks").observe("click", function(){
			showEditor("txtRemarks", 4000, "false");
		});
	}
}