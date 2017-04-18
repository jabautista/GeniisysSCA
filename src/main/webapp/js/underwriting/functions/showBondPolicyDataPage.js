function showBondPolicyDataPage(){
	try {
		var lineCd = $F("globalLineCd");
		if (!(("SU" == lineCd || objUWGlobal.menuLineCd == "SU") && ("" != $F("globalSublineCd")))){
			showMessageBox("You cannot access this menu.", imgMessage.ERROR);
			return false;
		} else {
			new Ajax.Request(contextPath+"/GIPIWBondBasicController?action=showBondPolicyDataPage",{
				method:"GET",
				parameters : {globalParId : $F("globalParId"),
							  globalAssdNo : $F("globalAssdNo"),
							  globalSublineCd : $F("globalSublineCd")},
				onCreate : function() {
					showNotice("Getting bond policy page, please wait...");
				},
				onComplete : function (response) {
					hideNotice();
					if(checkErrorOnResponse(response)){
						$("parInfoDiv").update(response.responseText);
						try{
							Effect.Appear($("parInfoDiv").down("div", 0), {duration: .001});
							setDocumentTitle("Bond Policy Data");
						} catch (e) {
							showErrorMessage("showBondPolicyDataPage", e);
						}
					}
				}
			});
		}
	} catch(e) {
		showErrorMessage("showBondPolicyDataPage", e);
	}
}