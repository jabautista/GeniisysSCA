/**
 * Shows Edit Peril Information Page
 * Module: GIEXS007- Edit Peril Information
 * @author Robert Virrey
 */
function showEditPerilInformationPage(packPolicyId, policyId){
	new Ajax.Updater("mainContents", contextPath+"/GIEXExpiryController?action=showEditPerilInformationPage",{
		method:"GET",
		evalScripts:true,
		asynchronous: true,
		parameters: {
			packPolicyId: packPolicyId,
			policyId: policyId
		},
		onCreate: showNotice("Loading Edit Peril Information page, please wait..."),
		onComplete: function () {
			hideNotice("");
			Effect.Appear($("mainContents").down("div", 0), {duration: .3}); 
			setDocumentTitle("Edit Peril Information");
			setModuleId("GIEXS007");
		}
	});
}