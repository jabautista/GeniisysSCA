function retrieveLossExpTax(){
	try{
		new Ajax.Updater("lossExpTaxTableGridDiv", contextPath+"/GICLLossExpTaxController",{
			method : "POST",
			parameters:{
				action: "getGiclLossExpTaxList",
				claimId: nvl(objCurrGICLClmLossExpense.claimId, 0),
				clmLossId: nvl(objCurrGICLClmLossExpense.claimLossId, 0),
				issCd : objCLMGlobal.issueCode,
				ajax : "1"
			},
			evalScripts: true,
			asynchronous: false,
			onCreate : function(){
				$("lossExpTaxTableGridDiv").hide();
			},
			onComplete : function(){
				$("lossExpTaxTableGridDiv").show();
			}
		});		
	}catch(e){
		showErrorMessage("retrieveLossExpTax", e);
	}
}