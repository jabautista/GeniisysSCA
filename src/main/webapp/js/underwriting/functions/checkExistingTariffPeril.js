/*Check update of item information
 * Gzelle 11282014
 * */
function checkExistingTariffPeril(itemNo) {
	var lineCd = getLineCd();
	var rep = "Y";
	var message = "";
	
	new Ajax.Request(contextPath+"/GIISPerilController?", {
		method: "GET",
		parameters: {
			action: "chkIfTariffPerilExsts",
			parId : (objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId")),
			itemNo : itemNo,
			lineCd : lineCd,
			sublineCd : nvl($("sublineCd") != null ? $F("sublineCd") : null, (objUWGlobal.packParId != null ? objCurrPackPar.sublineCd : $F("globalSublineCd")))
		},
		evalScripts: true,
		asynchronous: false,
		onComplete: function (response) {
			if(checkErrorOnResponse(response)){
				message = response.responseText;
				if (itemNo == 0 || itemNo == null) {
					rep = message;
				} else {
					if (message == "X") {
						if (lineCd == "FI") {
							if ((objDefaultPerilAmts.coverageCd != $F("coverage")) 
									|| (objDefaultPerilAmts.tariffZone != $F("tariffZone"))
									|| (objDefaultPerilAmts.tarfCd != $F("tarfCd"))
									|| (objDefaultPerilAmts.constructionCd  != $F("construction"))) {
								rep = "X";
							}
						}else if (lineCd == "MC") {
							if ((objDefaultPerilAmts.sublineTypeCd != $F("sublineType")) 
									|| (objDefaultPerilAmts.motorTypeCd != $F("motorType"))) {
								rep = "X";
							}
						}
					}
				}
			}
		}
	});
	return rep;
}