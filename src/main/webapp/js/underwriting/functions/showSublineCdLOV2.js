function showSublineCdLOV2(lineCd, moduleId, onOkFunc) {
	try {
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getSublineByLineCdLOV",
				page : 1,
				lineCd : lineCd
			},
			title : "Valid Values for Subline Code",
			width : 405,
			height : 386,
			columnModel : [ {
				id : "sublineCd",
				title : "Code",
				width : '70px',
				type : 'number'
			}, {
				id : "sublineName",
				title : "Name",
				width : '320px'
			} ],
			draggable : true,
			onSelect : onOkFunc
		});
	} catch (e) {
		showErrorMessage("showSublineCdLOV2", e);
	}
}