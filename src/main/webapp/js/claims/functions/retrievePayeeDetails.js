function retrievePayeeDetails(giclItemPeril){
	try{		
		new Ajax.Updater("payeeDetailsTableGridDiv", contextPath+"/GICLLossExpPayeesController",{
			method : "POST",
			parameters:{
				action: "getGiclLossExpPayeesList",
				claimId: nvl(giclItemPeril.claimId, 0),
				polIssCd: objCLMGlobal.policyIssueCode,
				itemNo: nvl(giclItemPeril.itemNo, 0),
				perilCd: nvl(giclItemPeril.perilCd, 0),
				groupedItemNo : nvl(giclItemPeril.groupedItemNo, 0),
				ajax : "1"
			},
			asynchronous : false,
			evalScripts : true,
			onCreate : function(){
				$("payeeDetailsTableGridDiv").hide();
			},
			onComplete : function(){
				$("payeeDetailsTableGridDiv").show();
			}
		});		
	}catch(e){
		showErrorMessage("retrievePayeeDetails", e);
	}
}