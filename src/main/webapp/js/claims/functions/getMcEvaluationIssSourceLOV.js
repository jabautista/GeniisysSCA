function getMcEvaluationIssSourceLOV(sublineCd){
	try{
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action : "getMcEvaluationIssSourceLOV",
							sublineCd : sublineCd,
							page : 1},
			title: "Issuing Source",
			width: 400,
			height: 400,
			columnModel : [
							{
								id : "issCd",
								title: "Issuing Code",
								width: '100px'
							},
							{
								id : "issName",
								title: "Issuing Name",
								width: '280px'
							}
						],
			draggable: true,
			onSelect : function(row){
				$("txtClmIssCd").value = row.issCd;
				$("txtClmYy").value = "";
				$("txtClmSeqNo").value = "";
				
				getMcEvaluationTG(null);
				populateEvalSumFields(null);
				populateOtherDetailsFields(null);
				toggleButtons(null);
				disableButton("btnSave");
				disableButton("btnAddReport");
			}
		});	
	}catch(e){
		showErrorMessage("getMcEvaluationIssSourceLOV",e);
	}
}