function showFireItemTypeLOV(){
	LOV.show({
		controller: "MarketingLOVController",
		urlParameters: {action : "getFireItemTypeLOV",
						page : 1},
		title: "Fire Item Type",
		width: 500,
		height: 386,
		columnModel : [	{	id : "frItemTypeDs",
							title: "Type",
							width: '391px'
						},
						{	id : "frItemType",
							title: "Item Type",
							width: '94px'
						}
					],
		draggable: true,
		onSelect: function(row){
			$("txtFrItemType").value = row.frItemType;
			$("txtDspFrItemType").value = unescapeHTML2(row.frItemTypeDs);
			$("txtDspFrItemType").focus();
	},
	onCancel: function(){
			$("txtDspFrItemType").focus();
	}
	  });
}