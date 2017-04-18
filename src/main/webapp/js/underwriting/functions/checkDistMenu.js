/**
 * Check before going to Distribution
 * @author Jerome Orio
 */
function checkDistMenu(moduleId){
	try{
		var ok = true;
		var parId = objUWGlobal.packParId == null ? (objUWGlobal.parId == null ? $F("globalParId") : objUWGlobal.parId) :  (objUWGlobal.packParId == null ? $F("globalPackParId") : objUWGlobal.packParId); //Added by tonio to resolve null errors
		new Ajax.Request(contextPath+"/GIUWPolDistController?action=checkDistMenu",{
			parameters:{
				moduleId: moduleId,
				parId: parId,
				isPack: (objUWGlobal.packParId == null || $F("globalPackParId") == "") ? 'N' : 'Y' //added parameter by Tonio July 13, 2011 for package
			},
			asynchronous: false,
			evalScripts: true,
			//onCreate: showNotice("Validating details, please wait..."),
			onComplete: function(response){
				var res = JSON.parse(response.responseText);
				if (checkErrorOnResponse(response)){
					var globalIssCd = objUWGlobal.issCd == null ? $F("globalIssCd") : objUWGlobal.issCd;
					var resIssCd = res.issCdRi == null ? null : res.issCdRi;
					//if (nvl(objUWGlobal.issCd,$F("globalIssCd")) != nvl(res.issCdRi,null)){
					if (globalIssCd != resIssCd){
						if (nvl(res.msgAlert,null) != null){
							//hideNotice();
							showMessageBox(res.msgAlert, res.msgIcon);
							ok = false;
							return false;
						}
					}
					setModuleId(moduleId);
				}
			}	
		});
		return ok;
	}catch(e){
		showErrorMessage("checkDistMenu", e);
	}
}