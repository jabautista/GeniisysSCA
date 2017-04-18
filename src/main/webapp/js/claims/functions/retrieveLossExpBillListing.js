function retrieveLossExpBillListing(){
	try{
		new Ajax.Updater("lossExpBillTableGridDiv", contextPath+"/GICLLossExpBillController",{
			method : "POST",
			parameters:{
				action: "getGiclLossExpBillTableGrid",
				claimId: nvl(objCurrGICLClmLossExpense.claimId, 0),
				clmLossId: nvl(objCurrGICLClmLossExpense.claimLossId, 0),
				ajax : "1"
			},
			evalScripts: true,
			asynchronous: false,
			onCreate : function(){
				$("lossExpBillTableGridDiv").hide();
			},
			onComplete : function(){
				$("lossExpBillTableGridDiv").show();
			}
		});		
	}catch(e){
		showErrorMessage("retrieveLossExpBillListing", e);
	}
}