/**
 * @author Joms Diago
 * @date 08.05.2013
 * @description Shows the GIACS204/List of Bills (Assured and Age Level)
 */
function showGIACS204(callFrom, fundCd, branchCd, selectedBranchCd, agingId,
		selectedAgingId, assdNo, fundDesc, branchName) {
	try {
		new Ajax.Request(
				contextPath + "/GIACInquiryController",
				{
					method : "POST",
					parameters : {
						action : "showGIACS204",
						fundCd : fundCd,
						branchCd : branchCd,
						selectedBranchCd : selectedBranchCd,
						agingId : agingId,
						selectedAgingId : selectedAgingId,
						assdNo : assdNo,
						fundDesc : fundDesc,
						branchName : branchName,
						callFrom : callFrom
					},
					asynchronous : false,
					evalScripts : true,
					onCreate : function() {
						showNotice("Loading List of Bills (Assured and Age Level), please wait...");
					},
					onComplete : function(response) {
						hideNotice();
						if (checkErrorOnResponse(response)) {
							if(callFrom == "GIACS207"){
								//$("dynamicDiv").update(response.responseText);
								$("billsForAnAssdMainDiv").style.display = "none";
								$("giacs207TempDiv").style.display = null;
								$("giacs207TempDiv").update(response.responseText);
							} else if(callFrom == "GIACS206"){
								$("billsForGivenAssdMainDiv").style.display = "none";
								$("giacs206TempDiv").style.display = null;
								$("giacs206TempDiv").update(response.responseText);
							} else {
								//$("dynamicDiv").update(response.responseText);
								$("billsByAssdAndAgeMainDiv").style.display = "none";
								$("giac202TempDiv").style.display = null;
								$("giac202TempDiv").update(response.responseText);
							}
						}
					}
				});
	} catch (e) {
		showErrorMessage("showGIACS204", e);
	}
}