/**
 * showNationalityLOV
 * Description: Retrieves the showEngineSeriesLOV2 LOV 
 * Added moduleId for extra functionality
 * @author Irwin Tabisora 9.15.11
 * */
function showEngineSeriesLOV2(sublineCd, carCompanyCd, makeCd,moduleId){
	try{
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getEngineSeriesLOV",
				sublineCd : sublineCd,
				carCompanyCd : carCompanyCd,
				makeCd : makeCd,
				page : 1			
			},
			title: "Engine Series",
			width : 400,
			height : 300,
			columnModel : [
			               {
			            	   id : "seriesCd",
			            	   title : "Series Cd",
			            	   width : '100px'
			               },
			               {
			            	   id : "engineSeries",
			            	   title : "Engine Series",
			            	   width : '260px'
			               }
			              ],
			draggable : true,
			onSelect : function(row){
				if(moduleId == "GICLS014other"){
					$("detMakeCd").value 		= row.makeCd;
					$("detMake").value 		= unescapeHTML2(row.make);
					$("detCarCompanyCd").value = row.carCompanyCd;
					$("detCarCompany").value 	= unescapeHTML2(row.carCompany);		
					$("detSeriesCd").value 	= row.seriesCd;
					$("detEngineSeries").value = unescapeHTML2(row.engineSeries);
				}else{
					$("carCompanyCd").value	= row.carCompanyCd;
					$("carCompany").value	= unescapeHTML2(row.carCompanyDesc);
					$("makeCd").value 		= row.makeCd;
					$("make").value 		= unescapeHTML2(row.makeDesc);				
					$("seriesCd").value 	= row.seriesCd;
					$("engineSeries").value = unescapeHTML2(row.engineSeries);
				}
			}			
		});
	}catch(e){
		showErrorMessage("showEngineSeriesLOV2", e);
	}
}