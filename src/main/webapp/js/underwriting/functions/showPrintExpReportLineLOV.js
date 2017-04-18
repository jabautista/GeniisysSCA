/**
 * LOV for GIEXS006
 * 
 * @author Bonok
 * @date 04.27.2012
 */

function showPrintExpReportLineLOV() {
	try {
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getPrintExpReportLineLOV",
				issCd : $("creditingLOV").value == "" ? $F("issCd")
						: $F("creditingLOV"),
				moduleId : "GIEXS006"
			},
			title : "Line",
			width : 405,
			height : 386,
			columnModel : [ {
				id : "lineCd",
				title : "Line Code",
				width : '80px',
				type : 'number'
			}, {
				id : "lineName",
				title : "Line Name",
				width : '308px'
			} ],
			draggable : true,
			onSelect : function(row) {
				if (row != undefined) {
					if ($("batch").checked) {
						$("lineLOV").value = unescapeHTML2(row.lineCd);
						$("lineName").value = unescapeHTML2(row.lineName);
					} else {
						$("lineCd").value = unescapeHTML2(row.lineCd);
						// $("sublineCd").value = "";
					}
				}
			}
		});
	} catch (e) {
		showErrorMessage("showPrintExpReportLineLOV", e);
	}
}