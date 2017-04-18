function getGiisParamValue(paramName) {
	try {
		var paramValue = "";
		new Ajax.Request(contextPath + "/GIISParameterController", {
			method : "POST",
			parameters : {
				action : "getParamValueV",
				paramName : paramName
			},
			asynchronous : false,
			evalScripts : true,
			onComplete : function(response) {
				hideNotice();
				paramValue =  response.responseText;
			}
		});
		return paramValue;
	} catch (e) {
		getGiisParamValue("getParamValueV", e);
	}
}