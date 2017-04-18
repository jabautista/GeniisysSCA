/**
 * Shows Statement of Account - Outward Facultative RI Page * moduleId: GIACS296 *
 * created by: shan * date created: 07.01.2013
 */
function showGIACS296Page() {
	try {
		new Ajax.Request(contextPath + "/GIACReinsuranceReportsController", {
			parameters : {
				action : "showGIACS296Page"
			},
			evalScripts : true,
			asynchronous : false,
			onCreate : showNotice("Loading, please wait..."),
			onComplete : function(response) {
				hideNotice();
				if (checkErrorOnResponse(response)) {
					$("dynamicDiv").update(response.responseText);
				}
			}
		});
	} catch (e) {
		showErrorMessage("showGIACS296Page", e);
	}
}