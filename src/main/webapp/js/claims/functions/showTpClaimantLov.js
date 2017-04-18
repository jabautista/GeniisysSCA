/**
 * Shows third party claimant lov
 * @author belle
 * @date 10.20.2011
 */
function showTpClaimantLov(signatory){
	try{
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action : "getTpClaimantLOV", 
							claimId: objCLMGlobal.claimId,
							signatory: signatory,
							page : 1},
			title: "LIST OF THIRD PARTY CLAIMANTS",
			width: 350,
			height: 340,
			columnModel : [	{	id : "payeeLastName",
								title: "Payee Name",
								width: '300px'
							}
						],
			draggable: true,
			onSelect: function(row){
				$('txtSignatory').value = row.payeeLastName;
			}
		  });
	}catch(e){
		showErrorMessage("showTpClaimantLov", e);
	}
}