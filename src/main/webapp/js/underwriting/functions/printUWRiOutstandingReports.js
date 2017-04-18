/**
 * Prints UW RI Outstanding Reports
 * Module: GIRIS051 - Generate RI Reports (Outstanding tab)
 * @author shan 01.30.2013
 */
function printUWRiOutstandingReports(){	
	try{		
		if($F("selDestination") == "SCREEN"){
			showMultiPdfReport(objRiReports.oar.reports);
		}else {
			for (var i=0; i < objRiReports.oar.reports.length; i++){
				var content = objRiReports.oar.reports[i].reportUrl;
				if($F("selDestination") == "PRINTER"){
					new Ajax.Request(content, {
						method: "POST",
						evalScripts: true,
						asynchronous: true,
						onComplete: function(response){
							hideNotice();
							if (checkErrorOnResponse(response)){
								showMessageBox("Printing Completed.", "I");
							}
						}
					});
				}else if("FILE" == $F("selDestination")){
					var fileType = "PDF";   // added by carlo de guzman 02/10/16 - Start
					
					if($("pdfRB").checked)
						fileType = "PDF";
					else if ($("csvRB").checked)
						fileType = "CSV"; 
					
					new Ajax.Request(content, {
						method: "POST",
						parameters : {destination : "FILE",
									  fileType    : fileType},
						evalScripts: true,
						asynchronous: true,
						onCreate: showNotice("Generating report, please wait..."),
						onComplete: function(response){
							hideNotice();
							if (checkErrorOnResponse(response)){
								if (fileType == "CSV"){ 
							copyFileToLocal(response, "csv");
							deleteCSVFileFromServer(response.responseText);
							console.log('1');
							} else 
							copyFileToLocal(response);
							}
						}
					}); // added by carlo de guzman 02/10/16 - End
				}else if("LOCAL" == $F("selDestination")){
					new Ajax.Request(content, {
						method: "POST",
						parameters : {destination : "LOCAL"},
						evalScripts: true,
						asynchronous: true,
						onComplete: function(response){
							hideNotice();
							if (checkErrorOnResponse(response)){
								printToLocalPrinter(response.responseText);
							}
						}
					});
				}
			}
		}
		objRiReports.oar.show_alert = true;
		
		objRiReports.oar.reports = [];
		
	}catch(e){
		showErrorMessage("printUWRiOutstandingReports", e);
	}
}