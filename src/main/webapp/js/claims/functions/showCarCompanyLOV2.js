/**
 * showCarCompanyLOV2
 * Description: Retrieves the showCarCompanyLOV2 LOV 
 * Added moduleId for extra functionality
 * @author Irwin Tabisora 9.15.11
 * */
function showCarCompanyLOV2(moduleId){
	try{
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getCarCompanyLOV",
				page : 1			
			},
			title: "Car Company",
			width : 400,
			height : 300,
			columnModel : [
			               {
			            	   id : "carCompanyCd",
			            	   title : "Car Company Cd",
			            	   width : '100px'
			               },
			               {
			            	   id : "carCompany",
			            	   title : "Car Company",
			            	   width : '260px'
			               }
			              ],
			draggable : true,
			onSelect : function(row){
				if(moduleId == "GICLS014other"){
					$("detCarCompanyCd").value = row.carCompanyCd;
					$("detCarCompany").value 	= unescapeHTML2(row.carCompany);
					$("detMakeCd").value		= "";
					$("detMake").value			= "";
					$("detEngineSeries").value 	= "";
					$("detSeriesCd").value = "";
				}else{
					$("carCompanyCd").value = row.carCompanyCd;
					$("carCompany").value 	= unescapeHTML2(row.carCompany);
					$("makeCd").value		= "";
					$("make").value			= "";
					$("seriesCd").value 	= "";
					$("engineSeries").value = "";
				}
			}			
		});
	}catch(e){
		showErrorMessage("showCarCompanyLOV2", e);
	}
}