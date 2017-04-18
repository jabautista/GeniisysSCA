function showTariffZoneLOV(){
	LOV.show({
		controller: "MarketingLOVController",
		urlParameters: {action : "getTariffZoneLOV",
						page : 1},
		title: "Tariff Zone",
		width: 500,
		height: 386,
		columnModel : [	{	id : "tariffZoneDesc",
							title: "Tariff Description",
							width: '391px'
						},
						{	id : "tariffZone",
							title: "Tariff Code",
							width: '94px'
						}
					],
		draggable: true,
		onSelect: function(row){
			$("txtTariffZone").value = row.tariffZone;
			$("txtDspTariffZone").value = unescapeHTML2(row.tariffZoneDesc);
			$("txtDspTariffZone").focus();
	},
	onCancel: function(){
			$("txtDspTariffZone").focus();
	}
	  });
}