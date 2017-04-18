//Policy/Endt Nos. For a Given Assured (Direct Premium Collections) : shan 12.04.2013
function showGiacs214() {
	try {
		new Ajax.Request(contextPath + "/GIACOrderOfPaymentController", {
			parameters : {
				action : "showGiacs214",
				moduleId : "GIACS214"
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
		showErrorMessage("showGiacs214", e);
	}
}