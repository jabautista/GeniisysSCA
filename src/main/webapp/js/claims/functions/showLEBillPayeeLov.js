/**
 * Payee Lov Used in Bill Information of GICLS030
 */
function showLEBillPayeeLov(giclItemPeril, payeeClassCd, payeeType){
	try{
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {
				action : "getAllLossExpPayeesList",
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
			onSelect : function(row){
				$("txtBillPayeeCd").value = unescapeHTML2(row.nbtPayeeName);
				$("txtBillPayeeCd").setAttribute("payeeCd", row.payeeNo);
			}
		});		
		
	}catch(e){
		showErrorMessage("showLEBillPayeeLov",e);
	}
}