/**
 * Adjster Lov Used in Bill Information of GICLS030
 */
function showLEBillAdjusterLov(giclItemPeril, payeeClassCd, payeeType){
	try{
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {
				action : "getAllLossExpPayeeAdjList",
				claimId: objCLMGlobal.claimId,
				itemNo : giclItemPeril.itemNo,
				perilCd: giclItemPeril.perilCd,
				payeeClassCd: payeeClassCd,
				payeeType: payeeType
				},
			title: "Adjuster List",
			width: 390,
			height: 390,
			columnModel : [	{	id : "adjCompanyCd",
								title: "Code",
								width: '75px',
								align: 'right'
							},
							{	id : "adjCoName",
								title: "Name",
								width: '300px'
							},
						],
			draggable: true,
			onSelect: function(row){
				$("txtBillPayeeCd").value = unescapeHTML2(row.adjCoName);
				$("txtBillPayeeCd").setAttribute("payeeCd", row.adjCompanyCd);
			}
		  });
	}catch(e){
		showErrorMessage("showLEBillAdjusterLov",e);
	}
}