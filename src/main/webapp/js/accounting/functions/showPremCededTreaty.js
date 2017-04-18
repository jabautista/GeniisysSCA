/**
 * Gzelle 07.01.2013 GIACS171 show Premium Ceded - Treaty
 */
function showPremCededTreaty() {
	new Ajax.Request(contextPath + "/GIACReinsuranceReportsController", {
		evalScripts : true,
		asynchronous : false,
		method : "POST",
		parameters : {
			action : "showPremCededTreaty"
		},
		onCreate : function() {
			showNotice("Loading Premium Ceded - Treaty, please wait...");
		},
		onComplete : function(response) {
			hideNotice();
			if (checkErrorOnResponse(response)) {
				$("dynamicDiv").update(response.responseText);
			}
		}
	});
}