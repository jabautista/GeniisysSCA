function showPrintExpReportSublineLOV() {
	try {
		var lineCd;
		if ($("batch").checked) {
			lineCd = $F("lineLOV");
		} else {
			lineCd = $F("lineCd");
		}
		LOV
				.show({
					controller : "UnderwritingLOVController",
					urlParameters : {
						action : "getPrintExpReportSublineLOV",
						lineCd : lineCd
					},
					title : "Subline",
					width : 405,
					height : 386,
					columnModel : [ {
						id : "sublineCd",
						title : "Subline Code",
						width : '80px',
						type : 'number'
					}, {
						id : "sublineName",
						title : "Subline Name",
						width : '308px'
					} ],
					draggable : true,
					onSelect : function(row) {
						if (row != undefined) {
							if ($("batch").checked) {
								$("sublineLOV").value = unescapeHTML2(row.sublineCd);
								$("sublineName").value = unescapeHTML2(row.sublineName);
							} else {
								$("sublineCd").value = unescapeHTML2(row.sublineCd);
							}
						}
					}
				});
	} catch (e) {
		showErrorMessage("showPrintExpReportSublineLOV", e);
	}
}