/**
 * Shows policy warranties and clauses list of values
 * wcTitle - for new lov version
 * @author gzelle
 * @date 12.26.2012
 */
function showWarrantyAndClauseLOV2(lineCd, notIn, generatedPrintSeqNo, wcTitle) {
	LOV.show({
		controller : "UnderwritingLOVController",
		urlParameters : {
			action : "getGIISWarrClaLOV2",
			lineCd : lineCd,
			notIn  : notIn,
			page   : 1,
			wcTitle : wcTitle
		},
		title : "List of Warranties and Clauses",
		width : 650,
		height : 386,
		columnModel : [ {
			id : "wcTitle",
			title : "Warranty Title",
			width : '450px'
		}, {
			id : "wcCd",
			title : "Code",
			width : '70px'
		}, {
			id : "wcSw",
			title : "Type",
			width : '100px'
		} ],
		draggable : true,
		onCancel: function() {
			$("txtWarrantyTitle").value = $("hidWcTitle").value;
		},
		onUndefinedRow: function() {
			showMessageBox("No record selected.", imgMessage.INFO);
			$("txtWarrantyTitle").value = $("hidWcTitle").value;
		},
		//autoSelectOneRecord: true,
		filterText: wcTitle,
		onSelect : function(row) {
			synchDetailsInWarrantyList(row, generatedPrintSeqNo);
			$("hidWcCd").value === "" ? $("txtWarrantyTitle").readOnly = true
					: $("txtWarrantyTitle").readOnly = false;
			//$("txtWarrantyTitle").value = row.wcTitle; commented and changed by reymon 11132013
			$("txtWarrantyTitle").value = unescapeHTML2(row.wcTitle);
			$("hidWcTitle").value = unescapeHTML2(row.wcTitle);
			changeTag = 1;
		}
	});
}