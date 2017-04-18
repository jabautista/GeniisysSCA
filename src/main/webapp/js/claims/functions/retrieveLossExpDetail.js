function retrieveLossExpDetail(giclClmLossExpense){
	try{		
		new Ajax.Updater("lossExpDtlTableGridDiv", contextPath+"/GICLLossExpDtlController",{
			method : "POST",
			parameters:{
				action: "getGiclLossExpDtlList",
				claimId: nvl(giclClmLossExpense.claimId, 0),
				clmLossId: nvl(giclClmLossExpense.claimLossId, 0),
				payeeType : nvl(giclClmLossExpense.payeeType, ""),
				lineCd : objCLMGlobal.lineCd,
				ajax : "1"
			},
			asynchronous : false,
			evalScripts : true,
			onCreate : function(){
				$("lossExpDtlTableGridDiv").hide();
			},
			onComplete : function(){
				$("lossExpDtlTableGridDiv").show();
			}
		});		
	}catch(e){
		showErrorMessage("retrieveLossExpDetail", e);
	}
}