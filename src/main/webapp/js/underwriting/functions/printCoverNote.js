/**
 * @author Veronica V. Raymundo
 * @date   08.10.2011
 */
function printCoverNote(reportId, destination, printerName, noOfCopies, updCNDetailsSw, noOfDays){
	var content = contextPath+"/PrintPolicyController?action=printCoverNote&globalParId="+$("globalParId").value
				  +"&noOfCopies="+noOfCopies+"&printerName="+printerName+"&reportId="+reportId+"&noOfDays="+noOfDays;
	
	if ("SCREEN" == destination) {//if SCREEN
		//window.open(content, "", "location=0, toolbar=0, menubar=0, fullscreen=1");
		showPdfReport(content, "Cover Note"); // andrew - 12.12.2011
		hideNotice("");
		updateCoverNoteDetails(noOfDays, updCNDetailsSw);
		hideOverlay();
	} else if("file" == destination){ //added by Jdiago 09.10.2014 : For printing covernote to file.
		new Ajax.Request(content, {
			parameters : {destination : "file",
						  fileType : "PDF"},
			onCreate: showNotice("Generating report, please wait..."),
			onComplete: function(response){
				hideNotice();
				if (checkErrorOnResponse(response)){
					copyFileToLocal(response, "reports");
				}
			}
		});
	} else { //PRINTER
		new Ajax.Request(content, {
			method: "POST",
			asynchronous: true,
			onComplete: function(response){
				if (checkErrorOnResponse(response)){
					updateCoverNoteDetails(noOfDays, updCNDetailsSw);
					hideNotice();
				}
			}
		});
		hideOverlay();
	}
}