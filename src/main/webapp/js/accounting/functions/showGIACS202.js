/**
 * @author Joms Diago
 * @date 07.31.2013
 * @description Shows the GIACS202/Bills by Assured and Age.
 */
function showGIACS202(callFrom, fundCd, branchCd, columnNo, multiSort,
		fundDesc, branchName) {
	try {
		new Ajax.Request(contextPath + "/GIACInquiryController", {
			method : "POST",
			parameters : {
				action : "showGIACS202",
				callFrom : callFrom,
				fundCd : fundCd,
				branchCd : branchCd,
				columnNo : columnNo,
				multiSort : multiSort,
				fundDesc : fundDesc,
				branchName : branchName
			},
			asynchronous : false,
			evalScripts : true,
			onCreate : function() {
				showNotice("Loading Bills by Assured and Age, please wait...");
			},
			onComplete : function(response) {
				hideNotice();
				if (checkErrorOnResponse(response)) {
					$("dynamicDiv").update(response.responseText);
				}
			}
		});
	} catch (e) {
		showErrorMessage("showGIACS202", e);
	}
}