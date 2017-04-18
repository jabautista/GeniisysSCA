function showMortgageeLOVGipis165(issCd, mortgName, notIn, onOkFunction){
	try{
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getMortgageeLOVGipis165",
				issCd : issCd,
				mortgName : mortgName,
				notIn : notIn
			},
			title : "Mortgagee",
			width : 375,
			height : 386,
			columnModel : [ {
				id : "mortgCd",
				title : "Mortgagee Cd",
				width : '100px'
			}, {
				id : "mortgName",
				title : "Mortgagee Name",
				width : '260px'
			} ],
			draggable : true,
			onSelect : onOkFunction
		});
	} catch (e) {
		showErrorMessage("showMortgageeLOVGipis165", e);
	}
}