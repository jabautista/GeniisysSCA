function retrieveLossExpCSL(){
	try{
		new Ajax.Updater("cslTableGridDiv", contextPath+"/GICLClaimLossExpenseController",{
			method : "POST",
			parameters:{
				action: "getCSLTableGridList",
				claimId: nvl(objCLMGlobal.claimId, 0),
				ajax : "1"
			},
			evalScripts: true,
			asynchronous: false,
			onCreate : function(){
				$("cslDiv").hide();
			},
			onComplete : function(){
				$("cslDiv").show();
			}
		});		
	}catch(e){
		showErrorMessage("retrieveLossExpCSL", e);
	}
}