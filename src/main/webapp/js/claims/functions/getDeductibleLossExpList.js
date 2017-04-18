function getDeductibleLossExpList(clmLossExpense, action){
	try{
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action : action,
				claimId   : objCLMGlobal.claimId,
				clmLossId : clmLossExpense.claimLossId},
			title: "For Loss/Expense..",
			width: 400,
			height: 400,
			columnModel : [
							{
								id : "lossExpCd",
								title: "Code",
								width: '100px'
							},
							{
								id : "lossExpDesc",
								title: "Description",
								width: '160px'
							},
							{
								id : "dtlAmt",
								title: "Detail Amount",
								width: '120px',
								align: 'right',
								geniisysClass : 'money'
							}
						],
			draggable: true,
			onSelect : function(row){
				onSelectDeductibleLossExp(row);
			}
		});	
	}catch(e){
		showErrorMessage("getDeductibleLossExpList",e);
	}
}