function getEngineSeriesAdverseLOV(carCompanyCd, makeCd){
	try{
		LOV.show({
			controller : "ClaimsLOVController",
			urlParameters : {
				action : "getEngineSeriesAdverseLOV",
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
					/*comment out and replaced since items do not exist and to allow retrieval of Engine Series by MAC 07/18/2013
					$("carCompanyCd").value	= row.carCompanyCd;
					$("carCompany").value	= unescapeHTML2(row.carCompanyDesc);
					$("makeCd").value 		= row.makeCd;
					$("make").value 		= unescapeHTML2(row.makeDesc);				
					$("seriesCd").value 	= row.seriesCd;
					$("engineSeries").value = unescapeHTML2(row.engineSeries);*/
					$("detSeriesCd").value 		= row.seriesCd;
					$("detEngineSeries").value 	= unescapeHTML2(row.engineSeries);
			}			
		});
	}catch(e){
		showErrorMessage("getEngineSeriesAdverseLOV", e);
	}
}