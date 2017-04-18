/**
 * @module GIACS180 - Statement of Account
 * @description Shows Statement of Account Main Page
 * @author Marie Kris Felipe
 * @date 06.06.2013
 */
function showSOAMainPage() {
	try {
		new Ajax.Request(
				contextPath + "/GIACCreditAndCollectionReportsController",
				{
					parameters : {
						action : "showSOABookedPolicies"
					},
					onCreate : function() {
						showNotice("Loading Statement of Account page, please wait...");
					},
					onComplete : function(response) {
						hideNotice("");
						if (checkErrorOnResponse(response)) {
							$("dynamicDiv").update(response.responseText);
						}
					}
				});
	} catch (e) {
		showErrorMessage("showSOAMainPage", e);
	}
}