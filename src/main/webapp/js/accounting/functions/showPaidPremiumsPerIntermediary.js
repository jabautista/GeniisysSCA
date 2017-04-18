// kenneth L. for paid premiums per intermediary 07.10.2013
function showPaidPremiumsPerIntermediary() {
	try {
		new Ajax.Request(
				contextPath + "/GIACCreditAndCollectionReportsController",
				{
					parameters : {
						action : "showPaidPremiumsPerIntermediary"
					},
					onCreate : function() {
						showNotice("Loading Paid Premiums per Intemediary, please wait...");
					},
					onComplete : function(response) {
						hideNotice("");
						if (checkErrorOnResponse(response)) {
							$("dynamicDiv").update(response.responseText);
						}
					}
				});
	} catch (e) {
		showErrorMessage("showPaidPremiumsPerIntermediary", e);
	}
}