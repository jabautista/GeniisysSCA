function getCompanyListLOV2(claimId, payeeTypeCd){
	try{
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action : "getCompanyListLOV",
							claimId: claimId,
							payeeTypeCd : payeeTypeCd,
							page : 1},
			title: "Company Type",
			width: 380,
			height: 400,
			columnModel : [
							{
								id : "dspCompany",
								title: "Parts",
								width: '350px'
							},
							{
								id : "payeeNo",
								title: "",
								width: '0',
								visible: false
							}
						],
			draggable: true,
			onSelect : function(row){
				$("payeeCd").value = row.payeeNo;
				$("dspCompany").value = unescapeHTML2(row.dspCompany);
				$("dspLaborCompany").value = unescapeHTML2(row.dspCompany);
				changeTag =1;
			}
		});	
	}catch(e){
		showErrorMessage("getCompanyListLOV2",e);
	}
}