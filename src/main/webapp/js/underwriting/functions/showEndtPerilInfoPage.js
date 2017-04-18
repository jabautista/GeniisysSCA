// mrobes 05.11.10
// Shows Endorsement Peril Information Page
function showEndtPerilInfoPage(){
	try {		
		new Ajax.Updater("perilInformationDiv", contextPath+"/GIPIWItemPerilController", {
			method: "GET",
			parameters: {action:			"showEndtPerilInfo",
						 globalParType:		$F("globalParType"),
						 globalParId: 		$F("globalParId"),
						 globalLineCd: 		$F("globalLineCd"),
						 globalSublineCd: 	$F("globalSublineCd"),
						 globalIssCd:		$F("globalIssCd"),
						 globalIssueYy:		$F("globalIssueYy"),
						 globalPolSeqNo:	$F("globalPolSeqNo"),
						 globalRenewNo:		$F("globalRenewNo"),
						 globalEffDate: 	$F("globalEffDate")
						 //itemNo:			$F("itemNo")
						 },
			asynchronous: true,
			evalScripts: true,
			onCreate: function() {
				setCursor("wait");
				//showSubPageLoading("showPerilInfoSubPage", true);
				showNotice("Getting Endorsement Peril Information, please wait...");
			},
			onComplete: function (response) {
				hideNotice("");
				setCursor("default");
				if(checkErrorOnResponse(response)){						
					//showSubPageLoading("showPerilInfoSubPage", false);	
					Effect.Appear($("parInfoDiv").down("div", 0), {
							duration: .1,
							afterFinish: function() {
								toggleEndtItemPeril($F("itemNo"), objGIPIWItemPeril, objGIPIItemPeril);
							}
						});
				}
			}
		});
	} catch (e) {
		showErrorMessage("showEndtPerilInfoPage", e);
	}
}