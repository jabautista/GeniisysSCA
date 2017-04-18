function getEvalDepCompanyLOV(evalId){
	try{
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action : "getDepCompanyLOV",
							evalId: evalId,
							page : 1},
			title: "Company Type",
			width: 380,
			height: 400,
			columnModel : [
							{
								id : "dspCompany",
								title: "Payee",
								width: '350px'
							},
							{
								id : "payeeCd",
								title: "",
								width: '0',
								visible: false
							}
						],
			draggable: true,
			onSelect : function(row){
				$("payeeCd").value = row.payeeCd;
				$("dspCompany").value = unescapeHTML2(row.dspCompany);
				changeTag =1;
			}
		});	
	}catch(e){
		showErrorMessage("getEvalDepCompanyLOV",e);
	}
}