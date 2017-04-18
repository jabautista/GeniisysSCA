function showVesselDescLOV(){
	LOV.show({
		controller: "MarketingLOVController",
		urlParameters: {action : "getVesselDescLOV",
						quoteId: objGIPIQuote.quoteId,
						page : 1},
		title: "Geography Description",
		width: 400,
		height: 386,
		columnModel : [	{	id : "vesselName",
							title: "Vessel Name",
							width: '386px'
						}
					],
		draggable: true,
		onSelect: function(row){
			$("txtVesselCd").value = row.vesselCd;
			$("txtDspVesselName").value = unescapeHTML2(row.vesselName);
			$("txtDspVesselName").focus();
	},
	onCancel: function(){
			$("txtDspVesselName").focus();
	}
	  });
}