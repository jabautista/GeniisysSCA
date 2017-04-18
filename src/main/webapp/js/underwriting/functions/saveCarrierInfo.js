// moved from carrierInformation.jsp
function saveCarrierInfo(reload) {
	try {		
		var parType = (objUWGlobal.parType != null ? objUWGlobal.parType : $F("globalParType"));
		if ($$("div[name='rowCarrier']").size() == 1 && $$("div[name='rowCarrier']")[0].down("input", 0).value == "MULTI" && $("policyNo") == null){//modified by: nica 10.28.2010
				showMessageBox("Another Carrier/Conveyance of must exist when using MULTIVESSEL.");
				$("inputVessel").focus();
		} else {
			new Ajax.Request("GIPIWVesAirController?action=saveCarrierInfo&globalParId="+(objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId")), {
				method: "POST",
				asynchronous: true,
				postBody: changeSingleAndDoubleQuotes(fixTildeProblem(Form.serialize("carrierInfoMainForm"))),
				onCreate: function () {
					setCursor("wait");
					$("carrierInfoMainForm").disable();
					$("btnSave").disable();
					$("btnCancel").disable();
					showNotice("Saving, please wait...");
				}, 
				onComplete: function (response)	{
					try {
						hideNotice();
						setCursor("default");
						$("carrierInfoMainForm").enable();
						$("btnSave").enable();
						$("btnCancel").enable();
						
						if (checkErrorOnResponse(response))	{
							$("forInsertDiv").update("");
							$("forDeleteDiv").update("");							
							setCarrierInfoForm(false, null);
							changeTag = 0;
							
							if (reload){
								showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, showCarrierInfoPage);
							} else {
								if(parType == "P"){
									showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
								}else if(parType == "E"){
									showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
								}
							}
						}
					} catch (e){
						showErrorMessage("saveCarrierInfo", e);
					}
				}
			});
		}
	} catch (e){
		showErrorMessage("saveCarrierInfo", e);
	} 
}