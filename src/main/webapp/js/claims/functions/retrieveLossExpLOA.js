function retrieveLossExpLOA(){
	try{
		new Ajax.Updater("loaTableGridDiv", contextPath+"/GICLClaimLossExpenseController",{
			method : "POST",
			parameters:{
				action: "getLOATableGridList",
				claimId: nvl(objCLMGlobal.claimId, 0),
				ajax : "1"
			},
			evalScripts: true,
			asynchronous: false,
			onCreate : function(){
				$("loaDiv").hide();
			},
			onComplete : function(){
				$("loaDiv").show();
			}
		});		
	}catch(e){
		showErrorMessage("retrieveLossExpLOA", e);
	}
}