function showUwReportsLineLOV() {
	try {
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getAllLineLOV",
				issCd : $("issCd").value,
				moduleId : "GIPIS901A"
			},
			title : "Valid values for line",
			width : 405,
			height : 386,
			columnModel : [ {
				id : "lineCd",
				title : "Line Cd",
				width : '80px'
			}, {
				id : "lineName",
				title : "Line Name",
				width : '308px'
			} ],
			draggable : true,
			onSelect : function(row) {
				if (row != undefined) {
					$("lineCd").value = row.lineCd;
					$("lineName").value = row.lineName;
					$("sublineCd").value = "";
					$("sublineName").value = "ALL SUBLINES";
				}
			}
		});
	} catch (e) {
		showErrorMessage("showUwReportsLineLOV", e);
	}
}