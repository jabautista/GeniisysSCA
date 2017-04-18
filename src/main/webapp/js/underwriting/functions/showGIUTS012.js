/**
 * Shows Update Binder Status Page
 * Module: GIUTS012 - Update Binder Status
 * @author Joms Diago 08.14.2013
 */
function showGIUTS012(){
	try{
		new Ajax.Updater("mainContents", contextPath+"/UpdateUtilitiesController?action=showGIUTS012",{
			method: "GET",
			asynchronous: true,
			evalScripts: true,
			onCreate: showNotice("Loading, Update Binder Status page, please wait..."),
			onComplete: function(response){
				hideNotice();
			}
		});
	}catch(e){
		showErrorMessage("showGIUTS012", e);
	}
}