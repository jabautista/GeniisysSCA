/**
 * Show OutFacul Prem Payts Page
 * 
 * @author tonio 02.14.2011
 * @version 1.0
 * @param
 * @return
 */
function showRITransOutFaculPremPayts() {
	try {
		objACGlobal.calledForm = "GIACS019";
		new Ajax.Updater(
				"transBasicInfoSubpage",
				contextPath
						+ "/GIACOutFaculPremPaytsController?action=showOutFaculPremPaytsTableGrid",
				{ // replaced showOutFaculPremPayts to
					// showOutFaculPremPaytsTableGrid replaced by: Steven
					method : "GET",
					parameters : {
						refresh : 1,
						gaccTranId : objACGlobal.gaccTranId
					},
					evalScripts : true,
					asynchronous : true,
					onCreate : function() {
						showNotice("Loading, please wait...");
					},
					onComplete : function(response) {
						hideNotice();
						var result = response.responseText;
					}
				});
	} catch (e) {
		showErrorMessage("showRITransOutFaculPremPayts", e);
	}
}