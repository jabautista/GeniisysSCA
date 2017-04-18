/**
 * Shows the GIACS003 TableGrid
 * 
 * @author Steven Ramirez
 */
var objGIACS003 = null; // andrew - 08282015 - SR 17425
function showJournalListing(action, action2, moduleId, fundCd, branchCd, tranId, loadingMsg, pageStatus, tranFlag) {
	try {// showJournalListing
		new Ajax.Request(contextPath + "/GIACJournalEntryController?action="
				+ action, {
			parameters : {
				action2 : action2,
				moduleId : moduleId,
				fundCd : fundCd,
				branchCd : branchCd,
				tranId : tranId,
				tranFlag : tranFlag, // andrew - 08252015 - 17425
				pageStatus : pageStatus == undefined || pageStatus == null ? "" : pageStatus
			},
			asynchronous : true,
			evalScripts : true,
			onCreate : function() {
				loadingMsg = loadingMsg == null ? "Loading, please wait..."
						: loadingMsg;
				showNotice(loadingMsg);
			},
			onComplete : function(response) {
				hideNotice();
				if (checkErrorOnResponse(response)) {
					hideAccountingMainMenus();
					$("mainContents").update(response.responseText);// dynamicDiv
				}
			}
		});
	} catch (e) {
		showErrorMessage("showJournalListing", e);
	}
}