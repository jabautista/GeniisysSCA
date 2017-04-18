function loadInvPerilsTableGrid(policyId,itemGrp){
	
	new Ajax.Updater("invPerilsTableDiv","GIPIOrigInvPerlController?action=getInvPerils",{
		method:"get",
		evalScripts: true,
		parameters: {
			policyId 	: nvl(policyId, 0),
			itemGrp		: nvl(itemGrp, 0)
		}
				
	});
}