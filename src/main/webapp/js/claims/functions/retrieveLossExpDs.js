function retrieveLossExpDs(giclClmLossExpense){
	try{		
		new Ajax.Updater("lossExpDsTableGridDiv", contextPath+"/GICLLossExpDsController",{
			method : "POST",
			parameters:{
				action: "getGiclLossExpDsList",
				claimId: giclClmLossExpense.claimId,
				clmLossId: giclClmLossExpense.claimLossId,
				ajax : "1"
			},
			asynchronous : false,
			evalScripts : true,
			onCreate : function(){
				$("lossExpDsTableGridDiv").hide();
			},
			onComplete : function(){
				$("lossExpDsTableGridDiv").show();
			}
		});		
	}catch(e){
		showErrorMessage("retrieveLossExpDs", e);
	}
}