function showPrintExpReportIntmLOV() {
	try {
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getPrintExpReportIntmLOV"
			},
			title : "Intermediary",
			width : 405,
			height : 386,
			columnModel : [ {
				id : "intmNo",
				title : "Intm No.",
				width : '80px',
				type : 'number'
			}, {
				id : "intmName",
				title : "Intermediary Name",
				width : '308px'
			} ],
			draggable : true,
			onSelect : function(row) {
				if (row != undefined) {
					$("intmLOV").value = formatNumberDigits(row.intmNo, 12);
					$("intmName").value = unescapeHTML2(row.intmName);
				}
			}
		});
	} catch (e) {
		showErrorMessage("showPrintExpReportIntmLOV", e);
	}
}