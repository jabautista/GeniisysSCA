//User per Function Maintenance shan : 12.16.2013
function showGiacs315() {
	try {		
		var div = (objACGlobal.callingForm == "GIACS314"? "userPerFunctionDiv" : "dynamicDiv");
		new Ajax.Request(contextPath + "/GIACUserFunctionsController", {
			method : "POST",
			parameters : {
				action : "showGiacs315",
				moduleId: objACGlobal.objGIACS314.moduleId,		
				functionCode: objACGlobal.objGIACS314.functionCode
			},
			asynchronous : false,
			evalScripts : true,
			onCreate : function() {
				showNotice("Loading, please wait...");
			},
			onComplete : function(response) {
				hideNotice();
				if (checkErrorOnResponse(response)) {
					$(div).update(response.responseText);
				}
			}
		});
	} catch (e) {
		showErrorMessage("showGiacs315", e);
	}
}