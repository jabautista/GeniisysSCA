/**
 * Function to set the report parameters to session and showing a generic report page that will hold the pdf report 
 * instead of directly opening a window which exposes the url and parameters
 * 
 * @author andrew robes
 * @date 12.09.2011 
 * @param reportUrl
 * @param reportTitle
 */
function showPdfReport(reportUrl, reportTitle){
	var checkUrl = reportUrl + "&checkIfReportExists=true";
	new Ajax.Request(checkUrl, {
		evalScripts: true,
		asynchronous: false,
		onComplete: function(r){
			if(r.responseText == "reportExists"){
				new Ajax.Request(contextPath + "/GIISUserController", {
					action: "POST",
					asynchronous : false,
					parameters : {action: "setReportParamsToSession",
								  reportUrl : reportUrl,
								  reportTitle : reportTitle},
					onComplete: function(response){
						window.open('pages/report.jsp', '', 'location=0, toolbar=0, menubar=0, fullscreen=1');
					}
				});	
			} else {
				showMessageBox(r.responseText, "I");
			}
		}
	});
}