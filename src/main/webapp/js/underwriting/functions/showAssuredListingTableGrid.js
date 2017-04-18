/**
 * Assured Listing Table Grid
 * @author distoresd
 */
function showAssuredListingTableGrid(){
	updateMainContentsDiv("/GIISAssuredController?action=getAssuredTableGrid&ajax=1",
	  "Loading assured table, please wait...");
}