function showLossExpenseGiclItemPeril(){
	try{
		new Ajax.Updater("giclItemPerilDiv", contextPath+"/GICLItemPerilController",{
			parameters:{
				action: "getItemPerilGrid3",
				claimId: objCLMGlobal.claimId,
				ajax: "1"
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response){
				if (checkErrorOnResponse(response)) {
					null;
				}	
			}
		});
	}catch(e){
		showErrorMessage("showLossExpenseGiclItemPeril", e);
	}
}