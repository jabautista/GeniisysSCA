// added fromClaim and tranType Parameters- irwin 7.4.2012
// added moduleTitle - apollo 8.11.2014
function showOtherBranchRequests(disbursementCd, clmSw, tranType,
		fromClaimItemInfo, moduleTitle) {
	try {
		new Ajax.Updater(
				fromClaimItemInfo == "Y" ? "basicInformationMainDiv"
						: "mainContents",
				contextPath
						+ "/GIACOtherBranchRequestController?action=showOtherBranchTableGrid",
				{
					method : "GET",
					parameters : {
						disbursementCd : disbursementCd,
						clmSw : clmSw,
						tranType : tranType,
						fromClaimItemInfo : fromClaimItemInfo,
						moduleTitle : moduleTitle
					},
					asynchronous : true,
					evalScripts : true,
					onCreate : function() {
						showNotice("Loading Branch Payment Requests Page. Please wait... </br>"
								+ contextPath);
					},
					onComplete : function(response) {
						hideNotice("");
						if (checkErrorOnResponse(response)) {
							objACGlobal.disbursementCd = disbursementCd;
							if (nvl(clmSw, "N") == "Y") {
								if (nvl(fromClaimItemInfo, "N") != "Y") {
									$("dynamicDiv").down("div", 0).hide(); // hide
																			// claims
																			// menu
								}

							} else {
								hideAccountingMainMenus();
								Effect.Appear($("mainContents").down("div", 0),
										{
											duration : .001
										});
								$("acExit").show();
							}

						}
					}
				});
	} catch (e) {
		showErrorMessage("showOtherBranchRequests", e);
	}
}