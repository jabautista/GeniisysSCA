/**
 * Checks if user has access to module using the DB function checkUserAccess2
 * @param moduleId
 * @return 	1 - full access
 * 			2 - no access
 * @author Marie Kris Felipe 05.20.2013
 */
function checkUserAccess2Gipis(moduleId){
	new Ajax.Request(contextPath+"/GIISUserController",{
		parameters: {
			action : "checkUserAccess2Gipis",
			moduleId : moduleId
		},
		evalScripts: true,
		asynchronous: false,
		onComplete: function(response) {
			if(response.responseText == "1"){
				if(moduleId == "GIPIS171"){
					showUpdateAddWarrantiesAndClauses();
				}
			}else{
				showMessageBox("You are not allowed to access this module.", "E");
			}
		}
	});
}