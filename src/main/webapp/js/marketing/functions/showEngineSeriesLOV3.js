function showEngineSeriesLOV3(carCompanyCd, makeCd){
	LOV.show({
		controller: "MarketingLOVController",
		urlParameters: {action : "getEngineSeriesLOV2",
						carCompanyCd: carCompanyCd,
						makeCd: makeCd,
						page : 1},
		title: "Engine Series",
		width: 500,
		height: 386,
		columnModel : [	{	id : "engineSeries",
							title: "Engine Series",
							width: '375px'
						},
						{	id : "seriesCd",
							title: "Series Code",
							width: '110px'
						}
					],
		draggable: true,
		onSelect: function(row){
			$("txtMakeCd").value = row.makeCd;
			$("txtCarCompanyCd").value = row.carCompanyCd;
			$("txtSeriesCd").value = row.seriesCd;
			$("txtMake").value = unescapeHTML2(row.make);
			$("txtDspCarCompanyCd").value = unescapeHTML2(row.carCompany);
			$("txtDspEngineSeries").value = unescapeHTML2(row.engineSeries);
			$("txtDspEngineSeries").focus();
	},
	onCancel: function(){
			$("txtDspEngineSeries").focus();
	}
	  });
}