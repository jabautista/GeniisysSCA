function showTariffCodeLOV(){
	LOV.show({
		controller: "MarketingLOVController",
		urlParameters: {action : "getTariffCodeLOV",
						page : 1},
		title: "Tariff Code",
		width: 500,
		height: 386,
		columnModel : [	{	id : "tariffDesc",
							title: "Tariff Description",
							width: '391px'
						},
						{	id : "tariffCd",
							title: "Tariff Code",
							width: '94px'
						}
					],
		draggable: true,
		onSelect: function(row){
			$("txtTarfCd").value = row.tariffCd;
			$("txtTarfCd").focus();
	},
	onCancel: function(){
			$("txtTarfCd").focus();
	}
	  });
}