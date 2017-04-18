/**
 * Shows Required Policy Document maintenance page
 * @author mac
 * @date 10.16.2012
 * 
 */
function showRequiredPolicyDocument(){
	clearObjectValues(objG035);
	updateMainContentsDiv("/GIISRequiredDocController?action=showGIIS035RequiredPolicyDocumentMaintenance&ajax=1","Loading Required Policy Document Maintenance, please wait...");
}