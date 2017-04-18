function loadInvoiceCommissionsTableGrid(policyId,itemGrp){
	
	new Ajax.Updater("invCommTableDiv","GIPIOrigCommInvoiceController?action=getInvoiceCommissions",{
		method:"get",
		evalScripts: true,
		parameters: {
			policyId 	: nvl(policyId, 0),
			itemGrp		: nvl(itemGrp, 0)
		}
				
	});
	
}