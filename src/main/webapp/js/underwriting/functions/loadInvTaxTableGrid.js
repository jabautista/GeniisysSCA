/**
 * Description - retrieves the list of invoice tax given the policyId and itemGrp
 * 
 * created by - mosesBC
 */
function loadInvTaxTableGrid(policyId,itemGrp){
	
	new Ajax.Updater("invTaxTableDiv","GIPIOrigInvTaxController?action=getInvTaxes",{
		method:"get",
		evalScripts: true,
		parameters: {
			policyId 	: nvl(policyId, 0),
			itemGrp		: nvl(itemGrp, 0)
		}
				
	});
}