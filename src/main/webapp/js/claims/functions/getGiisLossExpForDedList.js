/**
 * Gets the list of GIIS_LOSS_EXP records for Deductibles
 * @author Veronica V. Raymundo
 * 
 */

function getGiisLossExpForDedList(giclItemPeril, giclLossExpPayees, clmLossExpense){
	try{
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action : "getGiisLossExpForDedList",
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
				polEffDate: objCLMGlobal.strPolicyEffectivityDate2,
				expiryDate: objCLMGlobal.strExpiryDate2},
			title: "Deductibles",
			width: 600,
			height: 400,
			columnModel : [
							{
								id : "dedCd",
								title: "Ded. Code",
								width: '75px'
							},
							{
								id : "dedTitle",
								title: "Deductible Title",
								width: '180px'
							},
							{
								id : "dedType",
								title: "Deductible Type",
								width: '105px'
							},
							{
								id : "dedRate",
								title: "Deductible Rate",
								width: '105px',
								align: 'right',
								geniisysClass : 'rate'
							},
							{
								id : "dedAmount",
								title: "Deductible Amount",
								width: '122px',
								align: 'right',
								geniisysClass : 'money'
							},
							{
								id : "dedText",
								title: "Deductible Text",
								width: '190px'
							},
						],
			draggable: true,
			onSelect : function(row){
				onSelectLEDeductible(row);
			}
		});	
	}catch(e){
		showErrorMessage("getGiisLossExpForDedList",e);
	}
}