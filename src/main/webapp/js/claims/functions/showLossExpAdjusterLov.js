/**
 * Adjuster Lov Used in GICLS030
 */
function showLossExpAdjusterLov(giclItemPeril, payeeClassCd, payeeType){
	try{
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {
				action : "getLossExpPayeeAdjList",
				claimId: objCLMGlobal.claimId,
				itemNo : giclItemPeril.itemNo,
				perilCd: giclItemPeril.perilCd,
				payeeClassCd: payeeClassCd,
				payeeType: payeeType
				},
			title: "Adjuster List",
			width: 600,
			height: 400,
			columnModel : [	{	id : "adjCompanyCd",
								title: "Code",
								width: '50px',
								align: 'right'
							},
							{	id : "adjCoName",
								title: "Name",
								width: '250px'
							},
							{	id : "privAdjCd",
								title: "Private Adj. Code",
								width: '100px',
								align: 'right'
							},
							{	id : "payeeName",
								title: "Private Adj. Name",
								width: '200px'
							}
						],
			draggable: true,
			onSelect: function(row){
				checkIfGiclLossPayeesExist(payeeClassCd, row.adjCompanyCd, row.adjCoName, "adjusters");
				$("payee").focus();
				changeTag = 1;
			}
		  });
	}catch(e){
		showErrorMessage("showLossExpAdjusterLov",e);
	}
}