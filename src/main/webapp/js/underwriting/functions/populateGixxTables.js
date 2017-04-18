function populateGixxTables(reportId, destination, printerName, noOfCopies, lineCd){
	var action = "populateGixxTables";
	if ("0" != $F("globalPackParId") || $F("packPolFlag") == "Y"){
		action = "populatePackGixxTables";
	}
	
	new Ajax.Request(contextPath+"/GIPIPolbasicController?action="+action, {
		method: "GET",
		evalScripts: true,
		asynchronous: true,
		parameters: {
			policyId: $("policyId").value,
			extractId: $("extractId").value,
			parId: $("parId").value
		},
		onComplete: function(){
			printCurrentReport(reportId, destination, printerName, noOfCopies, 0, lineCd, 'Y'); 
				//edited by d.alcantara, 11/09/2011. Temporary. Required to pass suretyship instead of bonds for proper results
			//hideNotice("REPORT SENT TO "+destination+".");
		}
	});
}