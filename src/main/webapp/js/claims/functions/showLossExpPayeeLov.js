/**
 * Payee Lov Used in GICLS030
 */
function showLossExpPayeeLov(giclItemPeril, payeeClassCd, payeeType){
	try{
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {
				action : "getLossExpPayeesList",
				claimId: objCLMGlobal.claimId,
				assdNo : objCLMGlobal.assuredNo,
				itemNo : giclItemPeril.itemNo,
				perilCd: giclItemPeril.perilCd,
				payeeClassCd: payeeClassCd,
				payeeType: payeeType
				},
			title: "List of Payees",
			width: 390,
			height: 390,
			columnModel : [
							{
								id : "payeeNo",
								title: "Payee Code",
								width: '75px',
								type: 'number'
							},
							{
								id : "nbtPayeeName",
								title: "Payee",
								width: '300px'
							}
						],
			draggable: true,
			autoSelectOneRecord : true,
			onSelect : function(row){
				checkIfGiclLossPayeesExist(payeeClassCd, row.payeeNo, row.nbtPayeeName, "payee");
				$("payee").focus();
				//changeTag = 1;
			}
		});		
		
	}catch(e){
		showErrorMessage("showLossExpPayeeLov",e);
	}
}