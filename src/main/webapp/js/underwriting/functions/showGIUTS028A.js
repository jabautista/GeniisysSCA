/**
 * Shows Package Policy Reinstatement Page
 * Module: GIUTS028A - Package Policy Reinstatement
 * @author Joms Diago 07.29.2013
 */
function showGIUTS028A(){
	try{
		new Ajax.Updater("mainContents", contextPath+"/SpoilageReinstatementController?action=showGIUTS028A",{
			method: "GET",
			asynchronous: true,
			evalScripts: true,
			onCreate: showNotice("Loading, Package Policy Reinstatement page, please wait..."),
			onComplete: function(response){
				hideNotice();
			}
		});
	}catch(e){
		showErrorMessage("showGIUTS028A", e);
	}
}