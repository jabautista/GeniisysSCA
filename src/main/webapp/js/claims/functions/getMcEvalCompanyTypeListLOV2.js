function getMcEvalCompanyTypeListLOV2(){
	try{
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action : "getMcEvalCompanyTypeListLOV",
							page : 1},
			title: "Company Type",
			width: 380,
			height: 400,
			columnModel : [
							{
								id : "classDesc",
								title: "Parts",
								width: '350px'
							},
							{
								id : "payeeClassCd",
								title: "",
								width: '0',
								visible: false
							}
						],
			draggable: true,
			onSelect : function(row){
				$("payeeTypeCd").value = row.payeeClassCd;
				$("dspCompanyType").value = unescapeHTML2(row.classDesc);
				$("dspLaborComType").value = unescapeHTML2(row.classDesc);
				$("dspCompany").value ="";
				changeTag =1;
			}
		});	
	}catch(e){
		showErrorMessage("getMcEvalCompanyTypeListLOV2",e);
	}
}