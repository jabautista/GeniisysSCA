function updateWithTariffSw() {
	new Ajax.Request(contextPath+"/GIPIWItemPerilController?", {
		parameters: {
			action: "updateWithTariffSw",
			parId : (objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId")),
			withTariffSw : "N"
		},
		evalScripts: true,
		asynchronous: false,
		onComplete: function (response) {
			if(checkErrorOnResponse(response)){
				objDefaultPerilAmts.updateWithTariffSw = false;
			}
		}
	});
}