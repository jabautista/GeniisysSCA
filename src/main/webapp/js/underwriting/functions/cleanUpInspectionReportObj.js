function cleanUpInspectionReportObj(){
	inspectionReportObj = new Object();
	giis197parameters = new Object();
	inspectionReportObj.currentItems = new Array();
	inspectionReportObj.addedItems = new Array();
	inspectionReportObj.deletedItems = new Array();//Rey for the delete items
	inspectionReportObj.insertedWcObjects = new Array();
	inspectionReportObj.deletedWcObjects = new Array();
	inspectionReportObj.otherDtls = new Object();
}