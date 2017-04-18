function deleteWitemPerilTariff(itemNo,calledfrom) {
	var lineCd = getLineCd();
	
	new Ajax.Request(contextPath+"/GIPIWItemPerilController?", {
		parameters: {
			action: "deleteWitemPerilTariff",
			parId : (objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId")),
			lineCd : lineCd,
			itemNo : itemNo,
			sublineCd : nvl($("sublineCd") != null ? $F("sublineCd") : null, (objUWGlobal.packParId != null ? objCurrPackPar.sublineCd : $F("globalSublineCd")))
		},
		evalScripts: true,
		asynchronous: false,
		onComplete: function (response) {
			if(checkErrorOnResponse(response)){
				objDefaultPerilAmts.deleteWitemPerilTariff = false;
			}
		}
	});
}