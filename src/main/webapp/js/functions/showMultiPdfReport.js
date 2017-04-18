/**
 * Function to set the multiple reports to session and showing a generic report page that will hold the pdf report 
 * instead of directly opening a window which exposes the url and parameters
 * 
 * @author andrew robes
 * @date 01.26.2011 
 * @param reports - array of reports
 */
function showMultiPdfReport(reports){
	var checkUrl = reports[0].reportUrl + "&checkIfReportExists=true";
	new Ajax.Request(checkUrl, {
		onComplete: function(r){
			if(r.responseText == "reportExists"){
				new Ajax.Request(contextPath + "/GIISUserController", {
					action: "POST",
					asynchronous : false,
					parameters : {action: "setReportListToSession",
							  	  reportList : prepareJsonAsParameter(reports)},
					onComplete: function(response){
						for(var x=0; x<reports.length; x++){
							window.open('pages/multiReport.jsp?index='+x, '', 'location=0, toolbar=0, menubar=0, fullscreen=1');
						}
					}
				});
			} else {
				showMessageBox(r.responseText, "I");
			}
		}
	});	
}