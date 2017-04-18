/*	Gzelle 11252014
 * 	Description	: retrieve default peril amounts for PAR tagged as (with Tariff)
 */
function getDefPerilAmts(calledFrom) {
	try {
		var perilCd = $F("perilCd").empty() ? $("txtPerilName").getAttribute("perilCd") : $F("perilCd");
		var lineCd = (objUWGlobal.packParId != null ? objCurrPackPar.lineCd : objUWGlobal.lineCd);
		var sublineCd = nvl($("sublineCd") != null ? $F("sublineCd") : null, (objUWGlobal.packParId != null ? objCurrPackPar.sublineCd : $F("globalSublineCd")));
		objDefaultPerilAmts.tariffPeril = false; 	//determine if peril is based on tariff
		
		if (unformatCurrency("perilRate") == "0") {
			new Ajax.Request(contextPath+"/GIISPerilController?action=getDefPerilAmts",{
				method: "POST",
				parameters:{
					parId : (objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId")),
					lineCd : lineCd,
					sublineCd : sublineCd,
					perilCd : perilCd ,
					tsiAmt : $F("perilTsiAmt").replace(/,/g, ""),
					coverageCd : objDefaultPerilAmts.coverageCd, 
					sublineTypeCd : objDefaultPerilAmts.sublineTypeCd, 
					motortypeCd : objDefaultPerilAmts.motorTypeCd, 
					tariffZone : objDefaultPerilAmts.tariffZone, 
					tarfCd : objDefaultPerilAmts.tarfCd,
					constructionCd : objDefaultPerilAmts.constructionCd 
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					hideNotice("");
					checkCustomErrorOnResponse(response, function() {
						$("perilTsiAmt").value = "";
						return false;
					});
					
					if(checkErrorOnResponse(response)){
						var message = response.responseText.split("_*_");
						if (message[0] != null && message[1] != null && message[2] != null) {
							if (calledFrom == "perilTsiAmt") {
								if (($F("perilTsiAmt") != "0" || $F("perilTsiAmt") != "") && unformatCurrency("perilRate") == "0") {
									showConfirmBox("Tariff","Peril " + $F("txtPerilName") +
											" is maintained with tariff rates. Default amounts from Default Rate Maintenance will be applied.",
											"Ok", "Cancel", function() {
										$("perilTsiAmt").value = formatCurrency(message[0]);
										$("premiumAmt").value = formatCurrency(message[1]); 
										$("perilRate").value = formatToNineDecimal(message[2]);
									}, "");
								}else {
									$("perilTsiAmt").value = formatCurrency(message[0]);
									$("premiumAmt").value = formatCurrency(message[1]); 
									$("perilRate").value = formatToNineDecimal(message[2]);
								}
								getPostTextTsiAmtDetails2();
							}
							objDefaultPerilAmts.tariffPeril = true;
						}
					}
				}
			});
		}else {
			getPostTextTsiAmtDetails2();
		}
	} catch (e) {
		showErrorMessage("getDefPerilAmts", e);
	}
}