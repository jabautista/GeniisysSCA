/** Validate User Function Table Maintenance Claim Payee Page
 * Module: GICLS150 - Table Maintenance Claim Payee 
 * @author Fons Ellarina 05.17.2013
 */
function validateUserFunc(moduleName,funcCode) {
	try {
		new Ajax.Request(contextPath
				+ "/GICLClaimTableMaintenanceController", {
			method : "POST",
			parameters : {
				action : "validateUserFunc",
				moduleName : moduleName,
				funcCode : funcCode
			},
			asynchronous : false,
			evalScripts : true,
			onComplete : function(response) {
				hideNotice();
				var res = JSON.parse(response.responseText.replace(
						/\\/g, '\\\\'));
				if(res.result=="TRUE"){
					result = true;
				}else if(res.result=="FALSE"){
					result = false;
				}				
			}
		});
		return result;
	} catch (e) {
		showErrorMessage("validateUserFunc", e);
	}
}