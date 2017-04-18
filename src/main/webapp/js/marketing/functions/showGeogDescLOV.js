function showGeogDescLOV(){
	LOV.show({
		controller: "MarketingLOVController",
		urlParameters: {action : "getGeogDescLOV",
						quoteId: objGIPIQuote.quoteId,
						page : 1},
		title: "Geography Description",
		width: 500,
		height: 386,
		columnModel : [	{	id : "geogDesc",
							title: "Geography Description",
							width: '391px'
						},
						{	id : "geogType",
							title: "Type",
							width: '94px'
						}
					],
		draggable: true,
		onSelect: function(row){
			$("txtGeogCd").value = row.geogCd;
			$("txtDspGeogDesc").value = unescapeHTML2(row.geogDesc);
			$("txtDspGeogDesc").focus();
	},
	onCancel: function(){
			$("txtDspGeogDesc").focus();
	}
	  });
}