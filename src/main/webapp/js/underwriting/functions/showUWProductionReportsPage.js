/**
 * Shows UW Production Reports (Tabs)
 * Module: GIPIS901a - UW Production Reports
 * @author Marco Paolo Rebong
 */
function showUWProductionReportsPage(tabAction){
	try{
		new Ajax.Updater("uwReportsSubDiv", contextPath+"/GIPIUwreportsExtController?action=showProductionReportsPage",{
			method: "GET",
			parameters: {
				tabAction : tabAction
			},
			evalScripts: true,
			asynchronous: true,
			onCreate: function ()	{
				showNotice("Loading, please wait...");
			},
			onComplete: function() {
				hideNotice("");
				Effect.Appear($("uwReportsSubDiv").down("div", 0), {duration: .001});
			}
		});
	}catch(e){
		showErrorMessage("showUWProductionReportsPage",e);
	}
}