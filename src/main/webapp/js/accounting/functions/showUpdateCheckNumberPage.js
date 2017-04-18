/**
 * Shows Update Check Number page Module: GIACS049
 * 
 * @author skbati 05.29.2013
 */
function showUpdateCheckNumberPage() {
	try {
		new Ajax.Request(contextPath + "/GIACUpdateCheckNumberController", {
			parameters : {
				action : "showUpdateCheckNumberPage",
				refresh : "1"
			},
			onComplete : function(response) {
				$("dynamicDiv").update(response.responseText);
				enableSearch("searchCompanyLOV");
				enableSearch("searchBranchLOV");
			}
		});
	} catch (e) {
		showErrorMessage("showUpdateCheckNumberPage", e);
	}
}