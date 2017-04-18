function getEvalDepCompanyTypeLOV(evalId){
	try{
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action : "getDepCompanyTypeLOV",
							evalId: evalId,
							page : 1},
			title: "Company Type",
			width: 380,
			height: 400,
			columnModel : [
							{
								id : "dspCompanyType",
								title: "PayeeType",
								width: '350px'
							},
							{
								id : "payeeTypeCd",
								title: "",
								width: '0',
								visible: false
							}
						],
			draggable: true,
			onSelect : function(row){
				$("payeeTypeCd").value = row.payeeTypeCd;
				$("dspCompanyType").value = unescapeHTML2(row.dspCompanyType);
				changeTag =1;
			}
		});	
	}catch(e){
		showErrorMessage("getEvalDepCompanyTypeLOV",e);
	}
}