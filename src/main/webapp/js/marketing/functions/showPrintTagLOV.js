function showPrintTagLOV(){
	LOV.show({
		controller: "MarketingLOVController",
		urlParameters: {action : "getCgRefCodeLOV3", //changed to getCgRefCodeLOV3 to order by rv_low_value christian 03/13/13
						domain : "GIPI_WCARGO.PRINT_TAG",
						page : 1},
		title: "Print Tag",
		width: 390,
		height: 300,
		columnModel : [	{	id : "rvLowValue",
							title: "Print Tag",
							width: '100px'
						},
						{	id : "rvMeaning",
							title: "Meaning",
							width: '260px'
						}
					],
		draggable: true,
		onSelect: function(row){
			$("txtPrintTag").value = row.rvLowValue;
			$("txtDspPrintTagDesc").value = row.rvMeaning;
			$("txtDspPrintTagDesc").focus();
	},
	onCancel: function(){
			$("txtDspPrintTagDesc").focus();
	}
	  });
}