/**
 * Description - retrieves list of policy based on Assured
 * 
 * created by - mosesBC
 */
function getPolicyByAssuredTable(assdNo){
	
	new Ajax.Updater("policyByAssuredDiv","GIPIPolbasicController?action=getPolicyListByAssured",{
		method:"get",
		evalScripts: true,
		parameters: {
			assdNo:	assdNo
		}
	});
	
}