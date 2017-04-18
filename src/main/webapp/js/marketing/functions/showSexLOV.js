function showSexLOV(){
	LOV.show({
		controller: "MarketingLOVController",
		urlParameters: {action : "getCgRefCodeLOV2",
						domain : "SEX",
						page : 1},
		title: "Sex",
		width: 390,
		height: 300,
		columnModel : [	{	id : "rvLowValue",
							title: "Sex",
							width: '100px'
						},
						{	id : "rvMeaning",
							title: "Description",
							width: '260px'
						}
					],
		draggable: true,
		onSelect: function(row){
			$("txtSex").value = row.rvLowValue;
			$("txtSex").focus();
	},
	onCancel: function(){
			$("txtSex").focus();
	}
	  });
}