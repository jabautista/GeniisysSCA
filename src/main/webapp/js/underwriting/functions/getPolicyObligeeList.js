function getPolicyObligeeList(keyword){
	
	new Ajax.Updater("policyObligeeDiv","GIISObligeeController?action=getObligeeList",{
		method:"get",
		evalScripts: true,
		parameters:{
			//obligeeNo : obligeeNo
			keyword: keyword
		}
	});
	
}