/**
 * @author rey
 * @date 07-19-2011
 * @param obligeeNo
 */
function getPolicyByObligeeTable(obligeeNo){
	try{
		new Ajax.Updater("policyByObligeeDiv","GIPIPolbasicController?action=getPolicyListByObligee",{
			method:"get",
			evalScripts: true,
			parameters: {
				obligeeNo:	obligeeNo
			}
		});	
	}catch(e){		
		showErrorMessage("getPolicyByObligeeTable", e);
	}	
}