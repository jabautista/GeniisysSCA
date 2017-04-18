/**
 * Shows Collection Analysis Page moduleId: GIACS078 created by: Shan date
 * created: 06.25.2013
 */

function showCollectionAnalysisPage() {
	try {
		new Ajax.Request(contextPath + "/GIACCashReceiptsReportController", {
			parameters : {
				action : "showCollectionAnalysisPage"
			},
			asynchronous : false,
			evalScripts : true,
			onCreate : showNotice("Loading, please wait.."),
			onComplete : function(response) {
				hideNotice();
				if (checkErrorOnResponse(response)) {
					$("dynamicDiv").update(response.responseText);
				}
			}
		});
	} catch (e) {
		showErrorMessage("showCollectionAnalysisPage", e);
	}
}