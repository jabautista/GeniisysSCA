/**
 * Show acknowledgement receipt listing
 * 
 * @author andrew robes
 * @date 10.06.2011
 */
function showAcknowledgementReceiptListing(branchCd, moduleId) {
	try {
		new Ajax.Request(
				contextPath + "/GIACAcknowledgmentReceiptsController?",
				{
					method : "GET",
					parameters : {
						action : "getApdcPaytList",
						branchCd : branchCd || "",
						moduleId : moduleId || ""
					},
					evalScripts : true,
					onCreate : showNotice("Loading acknowledgement receipt listing, please wait..."),
					onComplete : function(response) {
						hideNotice();
						if (checkErrorOnResponse(response)) {
							$("mainContents").update(response.responseText);
							hideAccountingMainMenus();
							$("acExit").show();
						}
					}
				});
	} catch (e) {
		showErrorMessage("showAcknowledgementReceiptListing", e);
	}
}