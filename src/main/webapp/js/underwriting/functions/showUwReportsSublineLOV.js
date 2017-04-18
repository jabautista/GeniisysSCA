function showUwReportsSublineLOV() {
	try {
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getSublineLOV",
				lineCd : $("lineCd").value
			},
			title : "Valid values for subline",
			width : 405,
			height : 386,
			columnModel : [ {
				id : "sublineCd",
				title : "Subline Cd",
				width : '80px'
			}, {
				id : "sublineName",
				title : "Subline Name",
				width : '308px'
			} ],
			draggable : true,
			onSelect : function(row) {
				if (row != undefined) {
					$("sublineCd").value = row.sublineCd;
					$("sublineName").value = row.sublineName;
				}
			}
		});
	} catch (e) {
		showErrorMessage("showUwReportsSublineLOV", e);
	}
}