/**
 * Updates the global parameters for Package PAR
 * @author Veronica V. Raymundo
 * 
 */
function updatePackParParameters(){
	try {
		new Ajax.Request(contextPath+"/GIPIPackPARListController", {
			method: "POST",
			asynchronous: true,
			evalScripts: true,
			parameters: {action: 	  "setPackParParameters",
						 packParId:   (objUWGlobal.packParId != null ? objUWGlobal.packParId : $F("globalPackParId"))}, // andrew - 04.14.2011 - added condition to fix element is null error // formerly objUWGlobal.packParId - irwin, april 13, 2011
			onComplete: function(response) {
							 if(checkErrorOnResponse(response)){
								 $("uwParParametersDiv").update(response.responseText);							 
							 } else {
								showMessageBox(response.responseText, imgMessage.ERROR);
							 }
						}
		});
	} catch (e){
		showErrorMessage("updatePackParParameters", e);
	}		
}