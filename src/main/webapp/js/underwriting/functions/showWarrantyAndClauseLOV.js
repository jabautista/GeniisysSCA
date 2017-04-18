/**
 * Shows policy warranties and clauses list of values
 * 
 * @author andrew robes
 * @date 10.19.2011
 */
function showWarrantyAndClauseLOV(lineCd, notIn, generatedPrintSeqNo) {
	LOV.show({
		controller : "UnderwritingLOVController",
		urlParameters : {
			action : "getGIISWarrClaLOV",
			lineCd : lineCd,
			notIn : notIn,
			page : 1
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
		onSelect : function(row) {
			synchDetailsInWarrantyList(row, generatedPrintSeqNo);
			/*$("hidWcCd").value === "" ? $("txtWarrantyTitle").readOnly = true
					: $("txtWarrantyTitle").readOnly = false; removed by Jdiago 09.10.2014 - Maintainable so no need to edit warranty title*/
			changeTag = 1;
		}
	});
}