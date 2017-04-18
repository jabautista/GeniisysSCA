/**
 * @author Joms Diago
 * @date 08.06.2013
 * @description Shows the GIACS207/List of Bills (For an Assured)
 */
function showGIACS207(fundCd, branchCd, agingId, assdNo, fundDesc, branchName) {
	try {
		new Ajax.Request(
				contextPath + "/GIACInquiryController",
				{
					method : "POST",
					parameters : {
						action : "showGIACS207",
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
						showNotice("Loading List of Bills (For an Assured), please wait...");
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
		showErrorMessage("showGIACS207", e);
	}
}