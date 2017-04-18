//belle 02.06.2012 shows LOV for beneficiary No.
function showClmBenNoLOV(){
	try{
		var notIn = beneficiaryGrid.createNotInParam("beneficiaryNo");
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action : 	"getClmBenNoLOV",
							page : 		1,
							notIn: 		notIn,
							lineCd: 	objCLMGlobal.lineCd,
							sublineCd: 	objCLMGlobal.sublineCd,
							polIssCd: 	objCLMGlobal.policyIssueCode,
							issueYy: 	objCLMGlobal.issueYy,
							polSeqNo: 	objCLMGlobal.policySequenceNo,
							renewNo: 	objCLMGlobal.renewNo,
						    lossDate: 	dateFormat(objCLMGlobal.strLossDate, "dd-mmm-yyyy"),
							claimId:	objCLMGlobal.claimId,
							itemNo:		$F("txtItemNo"),
							groupedItemNo: $F("txtGrpItemNo")
			},
			title: "List of Beneficiary",
			width: 405,
			height: 386,
			columnModel:[	
			             	{	id : "beneficiaryNo",
								title: "Beneficiary No.",
								width: '70px',
								type: 'number'
							},
							{	id : "beneficiaryName",
								title: "Beneficiary Name",
								width: '320px'
							} 
						],
			draggable: true,
			onSelect : function(row){
				objCLMItem.newBeneficiary = row || [];
				$("beneficiaryName").value = unescapeHTML2(row.beneficiaryName);
				$("benAddress").value 	   = unescapeHTML2(row.beneficiaryAddr);
				$("dspBenPosition").value  = unescapeHTML2(row.dspBenPosition);
				$("dspCivilStatus").value  = unescapeHTML2(row.dspCivilStatus);
				$("age").value 			   = row.age;
				$("relation").value		   = unescapeHTML2(row.relation);
				$("dateOfBirth").value	   = unescapeHTML2(row.dateOfBirth);
				$("dspSex").value	   	   = unescapeHTML2(row.dspSex);
			},
			prePager: function(){
				tbgLOV.request.notIn = notIn;
			}
		});
	}catch(e){
		showErrorMessage("showClmBenNoLOV", e);
	}
}