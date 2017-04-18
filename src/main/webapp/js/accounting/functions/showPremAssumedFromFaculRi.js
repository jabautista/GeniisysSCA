/**
 * Gzelle 06.17.2013 GIACS171 show Premiums Assumed from Facultative RI
 */
function showPremAssumedFromFaculRi() {
	new Ajax.Request(
			contextPath + "/GIACReinsuranceReportsController",
			{
				evalScripts : true,
				asynchronous : false,
				method : "POST",
				parameters : {
					action : "showPremAssumedFromFaculRi"
				},
				onCreate : function() {
					showNotice("Loading Premiums Assumed from Facul RI, please wait...");
				},
				onComplete : function(response) {
					hideNotice();
					if (checkErrorOnResponse(response)) {
						$("dynamicDiv").update(response.responseText);
					}
				}
			});
}