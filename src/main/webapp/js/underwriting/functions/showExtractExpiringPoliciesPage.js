/**
 * Shows Extract Expiring Policies
 * Module: GIEXS001- Extract Expiring Policies
 * @author Robert Virrey
 */
function showExtractExpiringPoliciesPage(){
	new Ajax.Updater("mainContents", contextPath+"/GIEXExpiryController?action=showExtractExpiringPoliciesPage",{
		method:"GET",
		evalScripts:true,
		asynchronous: true,
		onCreate: showNotice("Loading Extract Expiring Policies page, please wait..."),
		onComplete: function () {
			Effect.Appear($("mainContents").down("div", 0), {duration: .001}); 
			setDocumentTitle("Extract Expiring Policies");
			hideNotice("");
		}
	});
}