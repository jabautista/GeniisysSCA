/**
 * Validate user function
 * 
 * @author Jerome Orio 01.21.2011
 * @version 1.0
 * @param functionCode -
 *            function code modName - module name
 * @return boolean
 */
function validateUserFunc2(functionCode, modName) {
	var result = false;
	new Ajax.Request(contextPath
			+ "/GIACDirectPremCollnsController?action=validateUserFunc", {
		method : "GET",
		parameters : {
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