function showDisbursementRequests(disbursementCd, branchCd) {
	try {
		new Ajax.Updater(
				"mainContents",
				contextPath
						+ "/GIACPaytRequestsController?action=showDisbursementRequests",
				{
					method : "GET",
					parameters : {
						disbursement : disbursementCd,
						branchCd : branchCd,
						paytReqFlag:	"N"
					},
					evalScripts : true,
					asynchronous : false,
					onCreate : function() {
						showNotice("Loading, please wait...");
					},
					onComplete : function() {
						hideNotice("");
						objACGlobal.otherBranchCd = branchCd;
						objACGlobal.callingModule = (objACGlobal.otherBranchCd != null
								&& objACGlobal.otherBranchCd != "" ? "GIACS055"
								: "GIACS000");
						objACGlobal.disbursementCd = disbursementCd;
						// setModuleId("GIACS016"); // andrew - disbursement
						// listing has no moduleId
						hideAccountingMainMenus();
						setDocumentTitle("Accounting - Disbursement Request Listing"); // marco
																						// -
																						// 05.04.2013
																						// -
																						// module
																						// id
																						// and
																						// title
						Effect.Appear($("mainContents").down("div", 0), {
							duration : .001
						});
					}
				});
	} catch (e) {
		showErrorMessage("showClaimPaymentRequests", e);
	}
}