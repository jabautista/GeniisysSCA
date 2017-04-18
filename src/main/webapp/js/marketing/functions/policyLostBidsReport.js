/**
 * 
 */
function policyLostBidsReport(){
	/*Modalbox.show(contextPath + "/PrintController?action=showPolicyLostBidsReportsPrintOptions&ajaxModal=1", {
		title : "Policy / Loss Bid Report",
		width : 400
	});*/ //replaced to overlay kenneth L 05.13.2014
	overlayLostBid = Overlay.show(contextPath + "/PrintController", {
		urlContent : true,
		urlParameters : {action : "showPolicyLostBidsReportsPrintOptions"},
		title : "Policy / Loss Bid Report",
		height : 300,
		width : 390,
		draggable : true
	});
}