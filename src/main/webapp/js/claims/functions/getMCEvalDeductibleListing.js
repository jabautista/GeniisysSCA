/**
 * Gets the list of Deductibles for MC Evaluation
 * @author Veronica V. Raymundo
 * 
 */

function getMCEvalDeductibleListing(mcEval){
	try{
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action : "getMCEvalDeductibleListing",
				claimId   : mcEval.claimId,
				itemNo    : mcEval.itemNo,
				perilCd   : mcEval.perilCd,
				lineCd    : mcEval.lineCd,
				sublineCd : mcEval.sublineCd,
				polIssCd  : mcEval.polIssCd,
				issueYy   : mcEval.polIssueYy,
				polSeqNo  : mcEval.polSeqNo,
				renewNo   : mcEval.polRenewNo,
				lossDate  : mcEval.lossDate},
			title: "Deductibles",
			width: 600,
			height: 400,
			columnModel : [
							{
								id : "lossExpCd",
								title: "Code",
								width: '75px'
							},
							{
								id : "lossExpDesc",
								title: "Deductibles",
								width: '200px'
							},
							{
								id : "amount",
								title: "Amount",
								width: '110px',
								align: 'right',
								geniisysClass : 'money'
							},
							{
								id : "dedRate",
								title: "Rate",
								width: '100px',
								align: 'right',
								geniisysClass : 'rate'
							},
							{
								id : "sublineCd",
								title: "Subline Code",
								width: '93px'
							}
						],
			draggable: true,
			onSelect : function(row){
				onSelectMcEvalDeductible(row);
			}
		});	
	}catch(e){
		showErrorMessage("getMCEvalDeductibleListing",e);
	}
}