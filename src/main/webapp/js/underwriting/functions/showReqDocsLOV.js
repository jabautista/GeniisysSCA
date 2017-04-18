/**
 * Shows required documents lov
 * 
 * @author agazarraga (alvin azarraga)
 * @date 05.02.2012
 */
function showReqDocsLOV(lineCd, sublineCd, notIn) {
	LOV.show({
		controller : "UnderwritingLOVController",
		urlParameters : {
			action : "getReqDocsListingLOV",
			lineCd : lineCd,
			sublineCd : sublineCd,
			notIn : notIn,
			page : 1
		},
		title : "List of Required Documents",
		width : 650,
		height : 386,
		columnModel : [ {
			id : 'docName',
			title : 'Document Name',
			width : '650px',
			align : 'left',
			filterOption : true
		}, {
			id : 'docCd',
			filterOption : true,
			visible : false
		} ],
		draggable : false,
		onSelect : function(row) {
			$("document").value = row.docName;
			$("docCd").value = row.docCd;
			
			changeTag = 1;
		}
	});

}