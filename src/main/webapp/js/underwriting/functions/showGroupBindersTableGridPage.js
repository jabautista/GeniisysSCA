/**
 * Shows Group/Ungroup Binders Table Grid Listing Page
 * Module: GIRIS053 - Group Binders
 * @author Emsy Bolaños
 */
function showGroupBindersTableGridPage(policyId){
	try{
		new Ajax.Updater("groupBinderListingDiv", contextPath+"/GIRIFrpsRiController?action=showBinderListing",{
			method: "GET",
			parameters: {
				moduleId: "GIRIS053",
				policyId: policyId
			},
			evalScripts: true,
			asynchronous: true,
			onCreate: function ()	{
				showNotice("Getting Binder Listing, please wait...");
			},
			onComplete: function ()	{
				hideNotice("");
				setModuleId();
				Effect.Appear($("underwritingDiv").down("div", 0), {
					duration: .001
				});	
			}
		});
	}catch(e){
		showErrorMessage("showGroupBindersTableGridPage",e);
	}
}