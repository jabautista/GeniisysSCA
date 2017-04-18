/**
 * For Bond Policy Data Endt
 * 05.11.2011 Irwin
 * */
function showEndtBondPolicyDataPage(){
	var lineCd = $F("globalLineCd");
	if (!(("SU" == lineCd || objUWGlobal.menuLineCd == "SU") && ("" != $F("globalSublineCd")))){
		showMessageBox("You cannot access this menu.", imgMessage.ERROR);
		return false;
	} else {
		new Ajax.Updater("parInfoDiv", contextPath+"/GIPIWBondBasicController?action=showEndtBondPolicyDataPage&"+Form.serialize("uwParParametersForm"),{
			method:"GET",
			evalScripts:true,
			asynchronous: true,
			onCreate: function() {
				showNotice("Getting bond policy page, please wait...");
			},
			onComplete: function () {
				try{
					Effect.Appear($("parInfoDiv").down("div", 0), {duration: .001});
					setDocumentTitle("Endorsement Bond Policy Data");
					hideNotice("");
				} catch (e) {
					showErrorMessage("showEndtBondPolicyDataPage", e);
				}
			}
		});	
	}
}