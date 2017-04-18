/**
 * @author reymon santos
 * */
function showSignatoryMaintenance(){
	updateMainContentsDiv("/GIISSignatoryController?action=getReportSignatory&ajax=1", "Loading signatory table, please wait...");
}