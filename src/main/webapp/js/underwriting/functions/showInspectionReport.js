function showInspectionReport(object){
	try {
		new Ajax.Updater("mainContents", contextPath+"/GIPIInspectionReportController?action=showInspectionReport",{
			evalScripts: true,
			asynchronous: false,
			parameters: {
				inspDataObj: JSON.stringify(object)
			}
		});
	} catch (e){
		showErrorMessage("showInspectionReport", e);
	}
}