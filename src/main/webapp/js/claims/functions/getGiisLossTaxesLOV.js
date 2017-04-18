function getGiisLossTaxesLOV(taxType, payeeCd, payeeSlTypeCd){
	try{
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action : "getGiisLossTaxesLOV",
							taxType: taxType,
							issCd: objCLMGlobal.issueCode},
			title: "Taxes",
			width: 400,
			height: 400,
			columnModel : [
							{
								id : "taxCd",
								title: "Code",
								width: '50px',
								align: 'right'
							},
							{
								id : "taxName",
								title: "Description",
								width: '250px'
							},
							{
								id : "taxRate",
								title: "Rate",
								width: '83px',
								align: 'right',
								geniisysClass : 'rate'
							}
						],
			draggable: true,
			onSelect : function(row){
				$("txtTaxCd").value = unescapeHTML2(row.taxName);
				$("txtTaxCd").setAttribute("taxCd", row.taxCd);
				$("txtTaxPct").value = formatToNineDecimal(row.taxRate);
				$("txtSLCode").value = "";
				$("txtTaxBaseAmt").value = "";
				//$("txtTaxBaseAmt").readOnly = false;
				$("txtTaxAmt").value = "";
				$("txtTaxLossExpCd").value = "";
				$("txtTaxLossExpCd").setAttribute("lossExpCd", "");
				if(nvl(row.slTypeCd, "") != ""){
					$("slCodeDiv").addClassName("required");
					if(row.slTypeCd == payeeSlTypeCd){ // added by: Nica 12.03.2012 - to set default SL Code value
						$("txtSLCode").value = lpad((payeeCd).toString(), 12, "0");
						$("txtTaxLossExpCd").value = "";
						$("txtTaxLossExpCd").setAttribute("lossExpCd", "");
					}
				}else{
					$("slCodeDiv").removeClassName("required");
				}
			}
		});	
	}catch(e){
		showErrorMessage("getGiisLossTaxesLOV",e);
	}
}