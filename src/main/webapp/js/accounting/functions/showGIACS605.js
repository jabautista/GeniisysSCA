//Dren Niebres 10.03.2016 SR-4572
//Function to call module GIACS605 from the Main Menu
function showGIACS605() {
	try {
		new Ajax.Request(contextPath + "/GIACUploadingController", {
			parameters : {
				action : "showGIACS605"
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
		showErrorMessage("Converted and Uploaded Files", e);
	}
}