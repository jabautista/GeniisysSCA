/**
 * Print generic report
 * @author niknok 
 * @param content
 * @param reportTitle 
 * @param afterPrintFunc -- added by: Nica 06.13.2013
 * @param withCsv -- if there's a value,then there's CSV. :) added by: steve
 */
function printGenericReport(content, reportTitle, afterPrintFunc, withCsv){
	try{
		if("screen" == $F("selDestination")){
			showPdfReport(content, reportTitle);
			if(nvl(afterPrintFunc, null) != null){
				afterPrintFunc();
			}
		}else if($F("selDestination") == "printer"){
			new Ajax.Request(content, {
				parameters : {printerName : $F("selPrinter"),
							  noOfCopies : $F("txtNoOfCopies")},
				onCreate : showNotice("Generating report, please wait..."),
				onComplete: function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						if(nvl(afterPrintFunc, null) != null){
							afterPrintFunc();
						}else{
							showMessageBox("Printing complete.", "S"); //added by steven 01.28.2013
						}
					}
				}
			});
		}else if("file" == $F("selDestination")){
			new Ajax.Request(content, {
				parameters : {destination : "FILE"},
				onCreate: showNotice("Generating report, please wait..."),
				onComplete: function(response){
					hideNotice();
					if (checkErrorOnResponse(response)){
						var repType = "reports";
					  	if(nvl(withCsv, null) != null){
							repType = "csv";
						}

						if($("geniisysAppletUtil") == null || $("geniisysAppletUtil").copyFileToLocal == undefined){
							showMessageBox("Local printer applet is not configured properly. Please verify if you have accepted to run the Geniisys Utility Applet and if the java plugin in your browser is enabled.", imgMessage.ERROR);
						} else {
							var message = $("geniisysAppletUtil").copyFileToLocal(response.responseText, repType);
							
							if(message.include("SUCCESS")){
								showWaitingMessageBox("Report file generated to " + message.substring(9), "I", function(){
									if(nvl(afterPrintFunc, null) != null){
										afterPrintFunc();
									}
									deleteCSVFileFromServer(response.responseText);
								});	
							} else {
								showMessageBox(message, "E");
							}
						}
					}
				}
			});
		}else if("local" == $F("selDestination")){
			new Ajax.Request(content, {
				parameters : {destination : "LOCAL"},
				onCreate : showNotice("Generating report, please wait..."),
				onComplete: function(response){
					hideNotice();
					if (checkErrorOnResponse(response)){
						var message = printToLocalPrinter(response.responseText);
						if(message != "SUCCESS"){
							showMessageBox(message, imgMessage.ERROR);
							return false;
						}
						if(nvl(afterPrintFunc, null) != null){
							afterPrintFunc();
						}
					}
				}
			});
		}
	}catch(e){
		showErrorMessage("printGenericReport", e);
	}	
}
