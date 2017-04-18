/**
 * Shows Spoil Package Policy/Endorsement Page
 * Module: GIUTS003A - Spoil Package Policy/Endorsement
 * @author Shan Bati 02.22.2013
 */
function showSpoilPostedPackagePolicy(){
	try{
		new Ajax.Updater("mainContents", contextPath+"/SpoilageReinstatementController?action=showSpoilPostedPackagePolicy",{
			method: "GET",
			asynchronous: true,
			evalScripts: true,
			onCreate: showNotice("Loading, please wait..."),
			onComplete: function(response){
				hideNotice();
			}
		});
	}catch(e){
		showErrorMessage("showSpoilPostedPackagePolicy", e);
	}
}