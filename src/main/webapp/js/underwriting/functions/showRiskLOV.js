/**
 * Shows risks lov
 * 
 * @author andrew
 * @date 04.25.2011
 */
function showRiskLOV(blockId) {
	LOV.show({
		controller : "UnderwritingLOVController",
		urlParameters : {
			action : "getGIISRiskLOV",
			blockId : blockId,
			page : 1
		},
		title : "Risks",
		width : 400,
		height : 300,
		columnModel : [ {
			id : "riskCd",
			title : "Code",
			width : '50px',  //changed from 0 to 50px by jeffdojello 03.28.2014
			visible : true //changed from false to true by jeffdojello 03.28.2014
		}, {
			id : "riskDesc",
			title : "Risk",
			width : '350px'
		} ],
		draggable : true,
		onSelect : function(row) {
			$("riskCd").value = row.riskCd;
			$("risk").value = unescapeHTML2(row.riskDesc);  //unescapeHTML2 added by jeffdojello 01.24.2014
		}
	});
}