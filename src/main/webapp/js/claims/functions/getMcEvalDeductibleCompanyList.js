function getMcEvalDeductibleCompanyList(evalId){
	try{
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action : "getMcEvalDeductibleCompanyList",
				            evalId: evalId},
			title: "History Status",
			width: 360,
			height: 400,
			columnModel : [
							{
								id : "dspCompany",
								title: "Company",
								titleAlign: 'center',
								width: '345px'
							}
						],
			draggable: true,
			onSelect : function(row){
				$("txtEvalDedCompany").value = unescapeHTML2(row.dspCompany);
				$("txtEvalDedCompany").setAttribute("payeeCd", row.payeeCd);
				$("txtEvalDedCompany").setAttribute("payeeTypeCd", row.payeeTypeCd);
			}
		});	
	}catch(e){
		showErrorMessage("getMcEvalDeductibleCompanyList",e);
	}
}