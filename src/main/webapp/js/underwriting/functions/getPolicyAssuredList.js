/**
 * Description - retrieves the list of assured based on keyword
 * 
 * created by - mosesBC
 */
function getPolicyAssuredList(keyword){

	new Ajax.Updater("policyAssuredDiv","GIPIPARListController?action=getAssuredList",{
		method:"get",
		evalScripts: true,
		parameters:{
			keyword : keyword
		}
	});
}