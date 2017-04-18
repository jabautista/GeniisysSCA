function showReserveDS(){
	var targetDiv = "dsDiv";
	try{
		new Ajax.Updater(targetDiv, contextPath+"/GICLClaimReserveController",{
			method : "POST",
			parameters:{
				action: "getReserveDs",
				claimId: nvl(objCLMGlobal.claimId, 0),
				ajax : "1"
			},
			evalScripts: true,
			asynchronous: false,
			onCreate : function(){
				$(targetDiv).hide();
			},
			onComplete : function(){
				$(targetDiv).show();
			}
		});
	}catch(e){
		showErrorMessage("show reserve ds", e);
	}
}