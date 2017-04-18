/**
 * Shows UW Production Reports
 * Module: GIPIS901a - UW Production Reports
 * @author Marco Paolo Rebong
 */
function showUWProductionReportsMainPage(){
	try{
		new Ajax.Updater("mainContents", contextPath+"/GIPIUwreportsExtController?action=showProductionReportsPage",{
			method: "GET",
			parameters: {
				tabAction : "showPolicyEndorsementTab"
			},
			evalScripts: true,
			asynchronous: true,
			onCreate: function (){
				showNotice("Loading, please wait...");
			},
			onComplete: function() {
				hideNotice("");
				Effect.Appear($("mainContents").down("div", 0), {duration: .001});
			}
		});
	}catch(e){
		showErrorMessage("showUWProductionReportsMainPage",e);
	}
}