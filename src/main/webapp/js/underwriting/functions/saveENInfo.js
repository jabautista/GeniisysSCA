// moved from additionalEngineeringInfo.jsp
function saveENInfo() {
	try {
		var enParam = prepareENParams();
		//var enParam = JSON.stringify(prepareENParams()).replace('"[', "[").replace(']"', "]").replace(/\\n/g, "&#10").replace(/\\/g, "").replace(/&#10/g,"\\\\n");
		var additionalParam = prepareENPrincipals();
		new Ajax.Request(contextPath+"/GIPIWENAdditionalInfoController?action=setENBasicInfo", {
			method: "POST",
			asynchronous: true,
			//postBody:   changeSingleAndDoubleQuotes(fixTildeProblem(Form.serialize("additionalENInfoForm"))),
			parameters: {additionalParam:  additionalParam,
						 enParam: enParam,
						 enSubline: (objUWGlobal.packParId != null ? objCurrPackPar.sublineCd : $F("enSubline")),
						 globalParId: (objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId")),
						 sublineName: $F("sublineCdParam")},	
			onCreate: function() {
				$("btnSave").disable();
				$("btnCancel").disable();
				showNotice("Saving, please wait...");
			},
			onComplete: function(response) {
				changeTag = 0;
				hideNotice("");
				$("btnSave").enable();
				$("btnCancel").enable();
				//showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);	
				clearENPrincipalVar();
				if(checkErrorOnResponse(response)) {
					showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);	
				} else {
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});	
	} catch(e) {
		showErrorMessage("saveENInfo", e);
	}
}