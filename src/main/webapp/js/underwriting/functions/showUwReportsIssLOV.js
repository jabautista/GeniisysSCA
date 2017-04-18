function showUwReportsIssLOV() {
	try {
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getIssCdNameLOV",
				lineCd : $("lineCd").value,
				moduleId : "GIPIS901A"
			},
			title : "Valid values for issue source",
			width : 405,
			height : 386,
			columnModel : [ {
				id : "issCd",
				title : "Issue Code",
				width : '80px'
			}, {
				id : "issName",
				title : "Issue Name",
				width : '308px'
			} ],
			draggable : true,
			onSelect : function(row) {
				if (row != undefined) {
					$("issCd").value = row.issCd;
					$("issName").value = row.issName;
				}
			}
		});
	} catch (e) {
		showErrorMessage("showUwReportsIssLOV", e);
	}
}