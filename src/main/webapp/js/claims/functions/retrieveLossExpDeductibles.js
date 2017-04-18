function retrieveLossExpDeductibles(){
	try{		
		new Ajax.Updater("lossExpDeductiblesTableGridDiv", contextPath+"/GICLLossExpDtlController",{
			method : "POST",
			parameters:{
				action: "getLossExpDeductiblesTableGrid",
				claimId: nvl(objCurrGICLClmLossExpense.claimId, 0),
				clmLossId: nvl(objCurrGICLClmLossExpense.claimLossId, 0),
				payeeType : nvl(objCurrGICLClmLossExpense.payeeType, ""),
				lineCd : objCLMGlobal.lineCd,
				ajax : "1"
			},
			asynchronous : false,
			evalScripts : true,
			onCreate : function(){
				$("lossExpDeductiblesTableGridDiv").hide();
			},
			onComplete : function(){
				$("lossExpDeductiblesTableGridDiv").show();
			}
		});		
	}catch(e){
		showErrorMessage("retrieveLossExpDeductibles", e);
	}
}