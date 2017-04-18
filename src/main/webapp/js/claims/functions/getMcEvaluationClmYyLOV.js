function getMcEvaluationClmYyLOV(sublineCd,clmIssCd){
	try{
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action : "getMcEvaluationClmYyLOV",
							sublineCd : sublineCd,
							issCd: clmIssCd,
							page : 1},
			title: "Claim Year",
			width: 360,
			height: 400,
			columnModel : [
							{
								id : "clmYy",
								title: "Claim Year",
								width: '300px'
							}
						],
			draggable: true,
			onSelect : function(row){
				$("txtClmYy").value = row.clmYy;
				$("txtClmSeqNo").value = "";
				
				getMcEvaluationTG(null);
				populateEvalSumFields(null);
				populateOtherDetailsFields(null);
				toggleButtons(null);
				disableButton("btnSave");
				disableButton("btnAddReport");
			}
		});	
	}catch (e) {
		showErrorMessage("getMcEvaluationSublineLOV",e);
	}
}