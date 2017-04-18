/**
 * Shows the Distribution by TSI/Prem (Group) page or GIUWS016 module 
 * @author Veronica V. Raymundo
 */

function showDistrByTsiPremGroup(params, loadRec){
	new Ajax.Updater("mainContents", contextPath+"/GIPIPolbasicPolDistV1Controller", {
		method: "GET",
		parameters: {
			action : "showDistrByTsiPremGroup",
			params : JSON.stringify(nvl(params,null)),
			loadRec : nvl(loadRec,'N')
		},
		evalScripts: true,
		asynchronous: false,
		onCreate: function(){
			showNotice("Getting Distribution by TSI/Prem (Group), please wait...");
		},
		onComplete: function(){
			hideNotice();
			setModuleId("GIUWS016");
			setDocumentTitle("One-Risk Distribution - TSI/Prem");
		}
	});
}