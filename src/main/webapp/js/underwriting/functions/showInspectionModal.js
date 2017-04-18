function showInspectionModal(){
	try{
		Modalbox.show(contextPath+"/GIPIInspectionReportController?action=showInspectionModal&ajaxModal=1", {
			title: "Search Inspection Information",
			width: 800
		});
	} catch(e){
		showErrorMessage("showInspectionModal", e);
	}
}