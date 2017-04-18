/**
 * @author Kris Felipe
 * Date created: 02.15.2013 
 * Description: shows the policySummary.jsp
 */

function showPolicySummaryPage(){
	//new Ajax.Updater("tabBasicInfoContents", contextPath+"/GIPIPolbasicController?action=showPolicySummary&",{
	//new Ajax.Updater("polMainInfoDiv",contextPath+"/GIXXPolbasicController?action=showPolicySummary",{ // eto dapat
	new Ajax.Updater("polMainInfoDiv",contextPath+"/GIXXPolbasicController?action=showPolicyMainInfo",{ // test lang
	//new Ajax.Request(contextPath+"/GIPIPolbasicController?action=showPolicySummary",{
		method: "POST",
		parameters: {
			lineCd		: $F("txtLineCd"),
			sublineCd	: $F("txtSublineCd"),
			issCd		: $F("txtIssCd"),
			issueYy		: $F("txtIssueYy"),
			polSeqNo	: $F("txtPolSeqNo"),
			renewNo		: $F("txtRenewNo"),
			refPolNo	: $F("txtRefPolNo")
		},
		evalScripts: true,
		asynchronous: true,
		onCreate: showNotice("Getting Policy Summary Information page, please wait..."),
		onComplete: function () {
			hideNotice();
			setDocumentTitle("Policy Summary Information");
		}
	});
	
}