/**
 * @author rey
 * @date 08.04.2011
 * bill payment schedule
 */
function showPaymentSchedule(object){
	try{
		new Ajax.Updater("policyPaymentSchedule","GIPIPolbasicController?action=getPaymentSchedule",{
			method: "get",
			evalScripts: true,
			asynchronous: false,
			parameters: {
				policyId : nvl(object, "") == "" ? 0 : object.policyId,
				itemNo   : nvl(object, "") == "" ? 0 : object.itemNo, // marco - 09.06.2012
				itemGrp  : nvl(object, "") == "" ? 0 : object.itemGrp // added params and nvl
			}
		});
	}
	catch(e){
		showErrorMessage("showPaymentSchedule", e);
	}
}