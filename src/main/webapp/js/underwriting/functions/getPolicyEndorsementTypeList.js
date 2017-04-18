/**
 * @author rey
 * @date 07-19-2011
 * @param keyword
 */
function getPolicyEndorsementTypeList(keyword){

	new Ajax.Updater("policyEndorsementTypeDiv","GIPIPARListController?action=getEndorsementTypeList",{
		method:"get",
		evalScripts: true,
		parameters:{
			keyword : keyword
		}
	});
}