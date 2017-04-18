/**
 * @author Joms Diago
 * @date 08.01.2013
 * @description Shows the GIACS203/List of Bills Under an Age Level.
 */
function showGIACS203(callFrom, pathFrom, fundCd, branchCd, selectedBranchCd,
		agingId, selectedAgingId, assdNo, fundDesc, branchName) {
	try {
		new Ajax.Request(
				contextPath + "/GIACInquiryController",
				{
					method : "POST",
					parameters : {
						action : "showGIACS203",
						callFrom : callFrom,
						pathFrom : pathFrom,
						fundCd : fundCd,
						branchCd : branchCd,
						selectedBranchCd : selectedBranchCd,
						agingId : agingId,
						selectedAgingId : selectedAgingId,
						assdNo : assdNo,
						fundDesc : fundDesc,
						branchName : branchName
					},
					asynchronous : false,
					evalScripts : true,
					onCreate : function() {
						showNotice("Loading List of Bills Under an Age Level, please wait...");
					},
					onComplete : function(response) {
						hideNotice();
						if (checkErrorOnResponse(response)) {
							if(callFrom == "GIACS204"){
								//$("dynamicDiv").update(response.responseText);
								$("billsAssdAndAgeLevelMainDiv").style.display = "none";
								$("giacs204TempDiv").style.display = null;
								$("giacs204TempDiv").update(response.responseText);
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
		showErrorMessage("showGIACS203", e);
	}
}