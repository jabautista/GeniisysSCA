function showBodyTypeLOV(){
	LOV.show({
		controller: "MarketingLOVController",
		urlParameters: {action : "getBodyTypeLOV",
						page : 1},
		title: "Type of Body Details",
		width: 500,
		height: 386,
		columnModel : [	{	id : "typeOfBody",
							title: "Type Of Body",
							width: '391px'
						},
						{	id : "typeOfBodyCd",
							title: "Type of Body Code",
							width: '94px'
						}
					],
		draggable: true,
		onSelect: function(row){
			$("txtTypeOfBodyCd").value = row.typeOfBodyCd;
			$("txtDspTypeOfBodyCd").value = unescapeHTML2(row.typeOfBody);
			$("txtDspTypeOfBodyCd").focus();
	},
	onCancel: function(){
			$("txtDspTypeOfBodyCd").focus();
	}
	  });
}