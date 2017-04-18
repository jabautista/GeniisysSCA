function getLossDtlLOV(clmLossId, payeeType, taxCd, taxType, action){
	try{
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action : action,
							lineCd: objCLMGlobal.lineCode,
							claimId: objCLMGlobal.claimId,
							clmLossId: clmLossId,
							payeeType: payeeType,
							taxCd: taxCd,
							taxType: taxType},
			title: "Loss/Expense",
			width: 400,
			height: 400,
			columnModel : [
							{
								id : "lossExpCd",
								title: "Code",
								width: '53px'
							},
							{
								id : "lossExpDesc",
								title: "Description",
								width: '230px'
							},
							{
								id : "lossAmt",
								title: "Loss Amount",
								width: '100px',
								align: 'right',
								geniisysClass : 'money'
							}
						],
			draggable: true,
			onSelect : function(row){
				$("txtTaxLossExpCd").value = unescapeHTML2(row.lossExpCd);
				$("txtTaxLossExpCd").setAttribute("lossExpCd", row.lossExpCd);
				$("txtTaxBaseAmt").value = formatCurrency(row.lossAmt);
				$("txtTaxBaseAmt").readOnly = true;
				$("hidWTax").value = row.wTax;
				computeTaxAmount();
				setValuesForWTaxAdvTagNetTag();
			}
		});	
	}catch(e){
		showErrorMessage("getLossDtlLOV",e);
	}
}