/**
 * @author rey
 * @date 08-03-2011
 * @param object
 */
function showBillTaxPage(object){
	try{
		new Ajax.Updater("policyTaxGroupList","GIPIPolbasicController?action=getBillTaxList",{
			method: "GET",
			evalScripts: true,
			asynchronous: false,
			parameters:{
				policyId : nvl(object, "") == "" ? 0 : object.policyId,
				itemNo   : nvl(object, "") == "" ? 0 : object.itemNo, // marco - 09.06.2012
				itemGrp  : nvl(object, "") == "" ? 0 : object.itemGrp // added params and nvl
			}
		});
	}
	catch(e){
		showErrorMessage("showBillTaxPage", e);
	}
}