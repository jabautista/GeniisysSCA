/**
 * Generating file report to local machine of user
 * @author andrew robes
 * @date 07.01.2013
 * @param response
 */

/*
 * Modified by Pol Cruz
 * 01.23.2014
 * Added onOkFunc (function to be executed after pressing Ok)
 * to handle execution of functions after showing the file path 
 */
function copyFileToLocal(response, subFolder, onOkFunc){ 
	try {
		subFolder = (subFolder == null || subFolder == "" ? "reports" : subFolder);
		if($("geniisysAppletUtil") == null || $("geniisysAppletUtil").copyFileToLocal == undefined){
			showMessageBox("Local printer applet is not configured properly. Please verify if you have accepted to run the Geniisys Utility Applet and if the java plugin in your browser is enabled.", imgMessage.ERROR);
		} else {
			var message = $("geniisysAppletUtil").copyFileToLocal(response.responseText, subFolder);
			if(message.include("SUCCESS")){
				showWaitingMessageBox("Report file generated to " + message.substring(9), "I", function(){
					if(onOkFunc != null)
						onOkFunc();
				});
			} else {
				showMessageBox(message, "E");
			}			
		}
		new Ajax.Request(contextPath + "/GIISController", {
			parameters : {
				action : "deletePrintedReport",
				url : response.responseText
			}
		});
	} catch(e){
		showErrorMessage("copyFileToLocal", e);
	}
}