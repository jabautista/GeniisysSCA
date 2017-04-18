/**
 * Shows Policy Reinstatement Page
 * Module: GIUTS028 - Policy Reinstatement
 * @author Joms Diago 07.25.2013
 */
function showGIUTS028(){
	try{
		new Ajax.Updater("mainContents", contextPath+"/SpoilageReinstatementController?action=showGIUTS028",{
			method: "GET",
			asynchronous: true,
			evalScripts: true,
			onCreate: showNotice("Loading, Policy Reinstatement page, please wait..."),
			onComplete: function(response){
				hideNotice();
			}
		});
	}catch(e){
		showErrorMessage("showGIUTS028", e);
	}
}