function showFireConstructionLOV(){
	LOV.show({
		controller: "MarketingLOVController",
		urlParameters: {action : "getFireConstructionLOV",
						page : 1},
		title: "Construction Code",
		width: 500,
		height: 386,
		columnModel : [	{	id : "constructionDesc",
							title: "Tariff Description",
							width: '391px'
						},
						{	id : "constructionCd",
							title: "Tariff Code",
							width: '94px'
						}
					],
		draggable: true,
		onSelect: function(row){
			$("txtConstructionCd").value = row.constructionCd;
			$("txtDspConstructionCd").value = unescapeHTML2(row.constructionDesc);
			$("txtDspConstructionCd").focus();
	},
	onCancel: function(){
			$("txtDspConstructionCd").focus();
	}
	  });
}