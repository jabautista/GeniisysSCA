/**
 * Gets the list of GIIS_LOSS_EXP records
 * @author Veronica V. Raymundo
 * 
 */

function getGiisLossExpLOV(giclItemPeril, giclLossExpPayees, clmLossExpense, notIn){
	try{
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action : "getGiisLossExpList",
				claimId   : clmLossExpense.claimId,
				clmLossId : clmLossExpense.claimLossId ,
				itemNo    : giclItemPeril.itemNo,
				perilCd   : giclItemPeril.perilCd,
				payeeType : giclLossExpPayees.payeeType,
				lineCd    : objCLMGlobal.lineCode,
				sublineCd : objCLMGlobal.sublineCd,
				polIssCd  : objCLMGlobal.policyIssueCode,
				issueYy   : objCLMGlobal.issueYy,
				polSeqNo  : objCLMGlobal.policySequenceNo,
				renewNo   : objCLMGlobal.renewNo,
				lossDate  : objCLMGlobal.strDspLossDate,
				notIn	  : nvl(notIn, "")},
				
			title: "Loss/Expense Details",
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
								width: '280px'
							}
						],
			draggable: true,
			onSelect : function(row){
				onSelectGiisLossExp(giclItemPeril, giclLossExpPayees, clmLossExpense, row);
			}
		});	
	}catch(e){
		showErrorMessage("getGiisLossExpLOV",e);
	}
}