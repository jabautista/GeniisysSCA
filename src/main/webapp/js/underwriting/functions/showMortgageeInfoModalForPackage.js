/**
 * Shows the mortgagee listing of Package PAR
 * @author Veronica V. Raymundo
 * 
 */
function showMortgageeInfoModalForPackage(packParId, itemNo){

	new Ajax.Updater("mortgageeInfo", contextPath+"/GIPIParMortgageeController?action=getPackParMortgagees&packParId="+packParId, {
		method: "GET",
		asynchronous: true,
		evalScripts: true,
		onCreate: function(){
			showNotice("Retrieving mortgagee, please wait...");
		},
		onComplete: function(){
			hideNotice("Retrieving complete!");
		}
	});
}