function retrieveClmLossExpense(giclLossExpPayees){
	try{		
		new Ajax.Updater("clmLossExpenseTableGridDiv", contextPath+"/GICLClaimLossExpenseController",{
			method : "POST",
			parameters:{
				action: "getClmLossExpList",
				claimId: nvl(giclLossExpPayees.claimId, 0),
				payeeType : nvl(giclLossExpPayees.payeeType, ""),
				payeeClassCd : nvl(giclLossExpPayees.payeeClassCd, ""),
				payeeCd: nvl(giclLossExpPayees.payeeCd, 0),
				itemNo: nvl(giclLossExpPayees.itemNo, 0),
				perilCd: nvl(giclLossExpPayees.perilCd, 0),
				clmClmntNo : nvl(giclLossExpPayees.clmClmntNo, 0),
				groupedItemNo : nvl(giclLossExpPayees.groupedItemNo, 0),
				ajax : "1"
			},
			asynchronous : false,
			evalScripts : true,
			onCreate : function(){
				$("clmLossExpenseTableGridDiv").hide();
			},
			onComplete : function(){
				$("clmLossExpenseTableGridDiv").show();
			}
		});		
	}catch(e){
		showErrorMessage("retrieveClmLossExpense", e);
	}
}