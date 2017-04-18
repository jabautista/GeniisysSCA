function showPrintExpReportIssourceLOV() {
	try {
		var lineCd;
		if ($("batch").checked) {
			lineCd = $F("lineLOV");
		} else {
			lineCd = $F("lineCd");
		}
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getPrintExpReportIssourceLOV",
				lineCd : lineCd,
				moduleId : "GIEXS006"
			},
			title : "Branch Code",
			width : 405,
			height : 386,
			columnModel : [ {
				id : "issCd",
				title : "Issue Code",
				width : '80px',
				type : 'number'
			}, {
				id : "issName",
				title : "Issue Name",
				width : '308px'
			} ],
			draggable : true,
			onSelect : function(row) {
				if (row != undefined) {
					if ($("batch").checked) {
						$("creditingLOV").value = unescapeHTML2(row.issCd);
						$("creditingName").value = unescapeHTML2(row.issName);
					} else {
						$("issCd").value = unescapeHTML2(row.issCd);
					}
				}
			}
		});
	} catch (e) {
		showErrorMessage("showPrintExpReportIssourceLOV", e);
	}
}