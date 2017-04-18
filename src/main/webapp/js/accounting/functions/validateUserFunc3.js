/**
 * Validate user function - check_user_override_function
 * 
 * @author Jerome Orio 10.21.2011
 * @version 1.0
 * @param userId -
 *            user id functionCode - function code modName - module name
 * @return boolean
 */
function validateUserFunc3(userId, functionCode, modName) {
	var result = false;
	new Ajax.Request(contextPath
			+ "/GIACDirectPremCollnsController?action=validateUserFunc3", {
		method : "GET",
		parameters : {
			userId : userId,
			funcCode : functionCode,
			moduleName : modName
		},
		asynchronous : false,
		evalScripts : true,
		onComplete : function(response) {
			result = response.responseText;
			if (result == "FALSE") {
				result = false;
			} else if (result == "TRUE") {
				result = true;
			}
		}
	});
	return result;
}