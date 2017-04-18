function showMakeLOV3(carCompanyCd){
	LOV.show({
		controller: "MarketingLOVController",
		urlParameters: {action : "getMakeLOV2",
						carCompanyCd: carCompanyCd,
						page : 1},
		title: "Make",
		width: 500,
		height: 386,
		columnModel : [	{	id : "make",
							title: "Make",
							width: '375px'
						},
						{	id : "carCompanyCd",
							title: "Car Company Code",
							width: '110px'
						}
					],
		draggable: true,
		onSelect: function(row){
			$("txtMakeCd").value = row.makeCd;
			$("txtCarCompanyCd").value = row.carCompanyCd;
			$("txtMake").value = unescapeHTML2(row.make);
			$("txtDspCarCompanyCd").value = unescapeHTML2(row.carCompany);
			$("txtMake").focus();
	},
	onCancel: function(){
			$("txtMake").focus();
	}
	  });
}