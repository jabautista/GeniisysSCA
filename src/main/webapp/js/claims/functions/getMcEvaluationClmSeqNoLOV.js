function getMcEvaluationClmSeqNoLOV(sublineCd,clmIssCd,clmYy){
	try{
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action : "getMcEvaluationClmSeqNoLOV",
							sublineCd : sublineCd,
							issCd: clmIssCd,
							clmYy: clmYy,
							page : 1},
			title: "Claim Sequence No.",
			width: 360,
			height: 400,
			columnModel : [
							{
								id : "clmSeqNo",
								title: "Claim Sequence Number",
								width: '300px'
							}
						],
			draggable: true,
			onSelect : function(row){
				$("txtClmSeqNo").value = row.clmSeqNo;
				getEvalPolInfo(sublineCd,clmIssCd,clmYy,row.clmSeqNo);
				//popGiclMcEval(null, sublineCd, clmIssCd, clmYy, row.clmSeqNo);
			}
		});	
	}catch (e) {
		showErrorMessage("getMcEvaluationClmSeqNoLOV",e);
	}
}