function showPrintExpReportAssuredLOV() {
	try {
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getPrintExpReportAssuredLOV"
			},
			title : "Assured",
			width : 405,
			height : 386,
			columnModel : [ {
				id : "assdNo",
				title : "Assured No.",
				width : '80px',
				type : 'number'
			}, {
				id : "assdName",
				title : "Assured Name",
				width : '308px'
			} ],
			draggable : true,
			onSelect : function(row) {
				if (row != undefined) {
					$("assuredLOV").value = formatNumberDigits(row.assdNo, 12);
					$("assuredName").value = unescapeHTML2(row.assdName);
				}
			}
		});
	} catch (e) {
		showErrorMessage("showPrintExpReportAssuredLOV", e);
	}
}