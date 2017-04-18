/**
 * @author rey
 * @date 08-04-2011
 * get the bill peril list
 */
function showBillPerilPage(object){
	try{
		new Ajax.Updater("policyPerilGroupList","GIPIPolbasicController?action=getBillPerilList",{
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
		showErrorMessage("showBillPerilPage", e);
	}
}