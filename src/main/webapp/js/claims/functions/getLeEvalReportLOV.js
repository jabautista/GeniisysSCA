function getLeEvalReportLOV(){
	try{
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action : "getLeEvalReportLOV",
				            claimId: objCLMGlobal.claimId},
			title: "History Status",
			width: 360,
			height: 400,
			columnModel : [
							{
								id : "evalNo",
								title: "Evaluation Number",
								titleAlign: 'center',
								width: '345px'
							}
							
						],
			draggable: true,
			onSelect : function(row){
				var evalId = row.evalId;
				var paramPerilCd = row.perilCd;
				
				showConfirmBox("Confirmation", "Do you want to create a settlement for this report?", "Yes", "No", 
						function(){createSettlementForLossExpEvalReport(evalId, paramPerilCd);}, function(){});
			}
		});	
	}catch(e){
		showErrorMessage("getLeEvalReportLOV",e);
	}
}