function getSlListForTaxTypeW(taxCd, action){
	try{
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action : action,
							taxCd: taxCd},
			title: "SL Codes",
			width: 400,
			height: 400,
			columnModel : [
							{
								id : "slCd",
								title: "SL Code",
								width: '83px',
								align: 'right'
							},
							{
								id : "slName",
								title: "SL Name",
								width: '300px'
							}
						],
			draggable: true,
			onSelect : function(row){
				$("txtSLCode").value = lpad((row.slCd).toString(), 12, "0");
				$("txtTaxLossExpCd").value = "";
				$("txtTaxLossExpCd").setAttribute("lossExpCd", "");
				$("hidSlTypeCd").value = row.slTypeCd;
			}
		});	
	}catch(e){
		showErrorMessage("getSlListForTaxTypeW",e);
	}
}