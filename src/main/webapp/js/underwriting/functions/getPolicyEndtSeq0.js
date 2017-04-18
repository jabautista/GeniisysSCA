/**
 *Description - searches the policy with endorsement number 0
 *			    for a given policy
 *created by  - mosesBC 
 */
function getPolicyEndtSeq0(policyId){
	var div = objGIPIS100.callingForm == "GIPIS000" ? "mainContents" : "dynamicDiv"; // added by: Nica 05.23.2012
	
	new Ajax.Updater(div, contextPath+"/GIPIPolbasicController?action=getPolicyEndtSeq0",{
		method: "POST",
		evalScripts: true,
		asynchronous: true,
		parameters: {
			policyId:	policyId
		},
		onCreate: showNotice("Loding Policy, please wait..."),
		onComplete: function () {
			hideNotice();
			setDocumentTitle("Policy");
		}
	});
}