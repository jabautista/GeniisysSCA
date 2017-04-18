function validateHistSeqNo(copySw){
	try{
		new Ajax.Request(contextPath + "/GICLClaimLossExpenseController", {
			parameters : {
				action: "validateHistSeqNo",
				claimId: nvl(objCurrGICLItemPeril.claimId, 0),
				itemNo: nvl(objCurrGICLItemPeril.itemNo, 0),
				perilCd: nvl(objCurrGICLItemPeril.perilCd, 0)
			},
			onCreate: function(){
				showNotice("Validating records, please wait...");
			},
			onComplete: function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					if(nvl(response.responseText, "EMPTY") != "EMPTY"){
						showConfirmBox("Generate/Print PLAs", response.responseText, "Ok", "Cancel", 
								function(){
									//fireEvent($("clmReservePrelimLossAdvice"), "click");
									showPrelimLossAdvice();
								}, 
								function(){});
					}else{
						if(copySw == "Y"){
							createAnotherHistory();
						}else{
							addGiclClmLossExpense();
						}
					}
				}else{
					showMessageBox(response.responseText, "E");
				}
			}
		});
	}catch(e){
		showErrorMessage("validateHistSeqNo", e);
	}
}