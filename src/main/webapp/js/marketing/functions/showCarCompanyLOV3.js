function showCarCompanyLOV3(){
	try{
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getCarCompanyLOV",
				page : 1			
			},
			title: "Car Company",
			width: 500,
			height: 386,
			columnModel : [
			               {	id : "carCompany",
							title: "Car Company Name",
							width: '375px'
						},
						{	id : "carCompanyCd",
							title: "Car Company Code",
							width: '110px'
						}
			              ],
			draggable : true,
			onSelect : function(row){
				if(row != undefined){
					$("txtCarCompanyCd").value = row.carCompanyCd;
					$("txtDspCarCompanyCd").value 	= unescapeHTML2(row.carCompany);
					$("txtMakeCd").value		= "";
					$("txtMake").value			= "";
					$("txtSeriesCd").value 	= "";
					$("txtDspEngineSeries").value = "";
				}				
			}			
		});
	}catch(e){
		showErrorMessage("showCarCompanyLOV", e);
	}
}