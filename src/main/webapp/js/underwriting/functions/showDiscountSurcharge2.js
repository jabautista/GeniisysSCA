/**
 * @author rey
 * @date 08.04.2011
 */
function showDiscountSurcharge2(object){
	try{
		new Ajax.Updater("policyDiscountSurcharge","GIPIPolbasicController?action=getDiscountSurcharge",{
			method: "get",
			evalScripts: true,
			asynchronous: false,
			parameters: {
				policyId : nvl(object, "") == "" ? 0 : object.policyId // marco - 09.06.2012 - added nvl
			}
		});
	}
	catch(e){
		showErrorMessage();
	}
}