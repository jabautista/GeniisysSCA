function getMcEvaluationSublineLOV(){
	try{
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action : "getMcEvaluationSublineLOV",
							page : 1},
			title: "Subline",
			width: 400,
			height: 400,
			columnModel : [
							{
								id : "sublineCd",
								title: "Subline Code",
								width: '100px'
							},
							{
								id : "sublineName",
								title: "Subline Name",
								width: '280px'
							}
						],
			draggable: true,
			onSelect : function(row){
				$("txtClmSublineCd").value = row.sublineCd;
				$("txtClmIssCd").value ="";
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
		showErrorMessage("getMcEvaluationSublineLOV",e);
	}
}