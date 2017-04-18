/**
 * @author Steven Ramirez
 * @date 04.27.2013
 * @description uses the database function check_user_per_iss_cd_acctg2.
 */
function checkUserPerIssCdAcctg(branchCd, moduleId) {
	try {
		var result = "0";
		new Ajax.Request(contextPath
				+ "/GIACJournalEntryController?action=checkUserPerIssCdAcctg",
				{
					method : "POST",
					asynchronous : false,
					evalScripts : true,
					parameters : {
						branchCd : branchCd,
						moduleId : moduleId
					},
					onComplete : function(response) {
						if (checkErrorOnResponse(response)) {
							result = response.responseText;
						}
					}
				});
		return result;
	} catch (e) {
		showErrorMessage("checkUserPerIssCdAcctg", e);
	}
}