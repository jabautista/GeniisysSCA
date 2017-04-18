/**
 * Shows Generate Binder (Non-Affecting Endorsement) page
 * Module: GIUTS024 - Generate Binder (Non-Affecting Endt)
 * @author Robert Virrey 
 * @since 01.04.12
 */
function showGenBinderNonAffEndtPage(policyId) {
		new Ajax.Updater("mainContents", contextPath+"/GIRIEndttextController?action=showGenBinderNonAffEndtPage", {
		method: "GET",
		parameters: {
			    moduleId: "GIUTS024",
			    policyId   : nvl(policyId,"")
		},
		evalScripts: true,
		asynchronous: true,
		onCreate: function ()	{
			showNotice("Loading Generate Binder (Non-Affecting Endorsement), please wait...");
		},
		onComplete: function(){
			hideNotice();
			setModuleId("GIUTS024");
			setDocumentTitle("Generate Binder (Non-Affecting Endt.)");
		}
	});
}