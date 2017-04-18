//Plate Number Inquiry (Direct Premium Collections) : shan 12.04.2013
function showGiacs213() {
	try {
		new Ajax.Request(contextPath + "/GIACOrderOfPaymentController", {
			parameters : {
				action : "showGiacs213",
				moduleId : "GIACS213"
			},
			asynchronous : false,
			evalScripts : true,
			onCreate : function() {
				showNotice("Loading, please wait...");
			},
			onComplete : function(response) {
				hideNotice();
				if (checkErrorOnResponse(response)) {
					$("mainContents").update(response.responseText);
				}
			}
		});
	} catch (e) {
		showErrorMessage("showGiacs213", e);
	}
}