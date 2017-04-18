/**
 * @author Joms Diago
 * @date 08.02.2013
 * @description Shows the GIACS206/Aging by Age Level (For a Given Assured)
 */
function showGIACS206(fundCd, branchCd, agingId, assdNo, fundDesc, branchName) {
	try {
		new Ajax.Request(
				contextPath + "/GIACInquiryController",
				{
					method : "POST",
					parameters : {
						action : "showGIACS206",
						fundCd : fundCd,
						branchCd : branchCd,
						agingId : agingId,
						assdNo : assdNo,
						fundDesc : fundDesc,
						branchName : branchName
					},
					asynchronous : false,
					evalScripts : true,
					onCreate : function() {
						showNotice("Loading Aging by Age Level (For a Given Assured), please wait...");
					},
					onComplete : function(response) {
						hideNotice();
						if (checkErrorOnResponse(response)) {
							//$("dynamicDiv").update(response.responseText);
							$("billsByAssdAndAgeMainDiv").style.display = "none";
							$("giac202TempDiv").style.display = null;
							$("giac202TempDiv").update(response.responseText);
						}
					}
				});
	} catch (e) {
		showErrorMessage("showGIACS206", e);
	}
}
