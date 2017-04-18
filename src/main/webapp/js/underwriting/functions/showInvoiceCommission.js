/**
 * @author rey
 * @date 08.04.2011
 */
function showInvoiceCommission(object){
	try{
		//new Ajax.Updater("policyInvoiceCommission","GIPIPolbasicController?action=getInvoiceCommission",{
		new Ajax.Updater("policyInvoiceCommission","GIPIPolbasicController?action=getInvoiceIntermediaries",{
			method: "get",
			evalScripts: true,
			asynchronous: false,
			parameters: {
				policyId : nvl(object, "") == "" ? 0 : object.policyId,
				premSeqNo: nvl(object, "") == "" ? 0 : object.premSeqNo, // marco - 09.06.2012
				lineCd   : nvl(object, "") == "" ? "" : object.lineCd    // added params and nvl
			}
		});
	}
	catch(e){
		showErrorMessage("showInvoiceCommision", e);
	}
}