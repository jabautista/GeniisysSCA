function showCivilStatusLOV(){
	LOV.show({
		controller: "MarketingLOVController",
		urlParameters: {action : "getCgRefCodeLOV2",
						domain : "CIVIL STATUS", //changed from CIVIL_STATUS reymon 03012013
						page : 1},
		title: "Civil Status",
		width: 390,
		height: 300,
		columnModel : [	{	id : "rvLowValue",
							title: "Civil Status",
							width: '100px'
						},
						{	id : "rvMeaning",
							title: "Description",
							width: '260px'
						}
					],
		draggable: true,
		onSelect: function(row){
			$("txtCivilStatus").value = row.rvLowValue;
			$("txtCivilStatus").focus();
	},
	onCancel: function(){
			$("txtCivilStatus").focus();
	}
	  });
}