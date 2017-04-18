/**
 * Description - shows the policyMainInformation.jsp
 * created by  - mosesBC
 * 
 */
function showPolicyMainInfoPage(policyId){
	new Ajax.Updater("polMainInfoDiv", contextPath+"/GIPIPolbasicController?action=showPolicyMainInfo&policyId="+policyId,{
		method: "POST",
		evalScripts: true,
		asynchronous: true,
		onCreate: showNotice("Getting Basic Policy Information page, please wait..."),
		onComplete: function () {
			hideNotice();
			setDocumentTitle("Policy Basic Information");
		}
	});
	
}