/**
 * Show Transaction Listing on Collections For Other Offices Module GIACS012
 * 
 * @author Nica Raymundo 12.15.2010
 * @return
 */
function searchTransactionNoDetails(pageNumber) {
	try {
		new Ajax.Updater(
				"searchResult",
				contextPath
						+ "/GIACCollnsForOtherOfficeController?action=getTransactionNoListing",
				{
					onCreate : function() {
						showLoading("searchResult",
								"Getting list, please wait...", "100px");
					},
					onException : function() {
						showFailure('searchResult');
					},
					parameters : {
						pageNo : pageNumber,
						keyword : $F("keyword")
					},
					asynchronous : true,
					evalScripts : true
				});
	} catch (e) {
		showErrorMessage("searchTransactionNoDetails", e);
		// showMessageBox("searchTransactionNoDetails: " + e.message);
	}
}