function showSublineTypeLOV(){
	LOV.show({
		controller: "MarketingLOVController",
		urlParameters: {action : "getSublineTypeLOV",
						sublineCd: objGIPIQuote.sublineCd,
						page : 1},
		title: "Subline Type Details",
		width: 500,
		height: 386,
		columnModel : [	{	id : "sublineTypeDesc",
							title: "Subline Type Description",
							width: '375px'
						},
						{	id : "sublineTypeCd",
							title: "Subline Type Code",
							width: '110px'
						}
					],
		draggable: true,
		onSelect: function(row){
			$("txtSublineTypeCd").value = row.sublineTypeCd;
			$("txtDspSublineTypeCd").value = unescapeHTML2(row.sublineTypeDesc);
			$("txtDspSublineTypeCd").focus();
	},
	onCancel: function(){
			$("txtDspSublineTypeCd").focus();
	}
	  });
}