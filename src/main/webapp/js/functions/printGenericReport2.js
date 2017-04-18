/**
 * Print generic report without the SCREEN destination
 * used for multiple reports
 * @author niknok 
 * @param content
 */
function printGenericReport2(content){
	try{
		if("printer" == $F("selDestination")){
			new Ajax.Request(content, {
				method: "POST",
				evalScripts: true,
				asynchronous: false,
				onCreate : showNotice("Generating report, please wait..."),
				onComplete: function(response){
					if (checkErrorOnResponse(response)){
						showMessageBox("Printing complete.", "I");
					}
				}
			});	
		}else if("file" == $F("selDestination")){
			new Ajax.Request(content, {
				method: "POST",
				evalScripts: true,
				asynchronous: true,
				onCreate: showNotice("Generating report, please wait..."),
				onComplete: function(response){
					hideNotice();
					//SR-5412 jmm
					var repType = "reports";
				    if(response.responseText.contains(".csv")){
				    	repType = "csv";
				    }
				    //end SR-5412
					if (checkErrorOnResponse(response)){
						if($("geniisysAppletUtil") == null || $("geniisysAppletUtil").copyFileToLocal == undefined){
							showMessageBox("Local printer applet is not configured properly. Please verify if you have accepted to run the Geniisys Utility Applet and if the java plugin in your browser is enabled.", imgMessage.ERROR);
						} else {
							var message = $("geniisysAppletUtil").copyFileToLocal(response.responseText, repType);
							if(message.include("SUCCESS")){
								showMessageBox("Report file generated to " + message.substring(9), "I");
							} else {
								showMessageBox(message, "E");
							}
						}
					}
				}
			});
		}else if("local" == $F("selDestination")){
			new Ajax.Request(content, {
				method: "POST",
				evalScripts: true,
				asynchronous: true,
				onCreate : showNotice("Generating report, please wait..."),
				onComplete: function(response){
					hideNotice();
					if (checkErrorOnResponse(response)){
						var message = printToLocalPrinter(response.responseText);
						if(message != "SUCCESS"){
							showMessageBox(message, imgMessage.ERROR);
						}
					}
				}
			});
		}
	}catch(e){
		showErrorMessage("printGenericReport", e);
	}
}