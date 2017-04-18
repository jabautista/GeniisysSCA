//dren 06.10.2015
//Function to call module GIACS606 from the Main Menu
function showGIACS606() {
	try {
		new Ajax.Request(contextPath + "/GIACUploadingController", {
			parameters : {
				action : "showGIACS606"
			},
			asynchronous : false,
			evalScripts : true,
			onCreate : function() {
				showNotice("Loading, please wait...");
			},
			onComplete : function(response) {
				hideNotice();
				if (checkErrorOnResponse(response)) {
					hideAccountingMainMenus();
					$("mainContents").update(response.responseText);
					$("acExit").show();
				}
			}
		});
	} catch (e) {
		showErrorMessage("Converted Records Per Status", e);
	}
}