/*	Created by	: d. alcantara 
 *  Date : 		  10.29.2010
 * 	Description : Shows the additional engineering items page
 */
function showAdditionalENInfoPage() {
	try {
		var containerDiv = (objUWGlobal.packParId != null ? objCurrPackPar.containerDiv : "parInfoDiv"); // added by andrew - 03.28.2011
		Effect.Fade($("parInfoDiv").down("div", 0), {
			duration: .001,
			afterFinish: function() {
				new Ajax.Updater(containerDiv, contextPath+"/GIPIWENAdditionalInfoController", {
					method: 		"GET",
					parameters: 	{
						action:		"showAdditionalInfo",//$F("globalParType") == 'E' ? "showEndtAdditionalInfo" : "showAdditionalInfo",
						globalParId:    (objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId")),
						globalParNo:    (objUWGlobal.packParId != null ? objCurrPackPar.parNo : $F("globalParNo")),
						globalAssdNo:   (objUWGlobal.packParId != null ? objCurrPackPar.assdNo : $F("globalAssdNo")),
						globalAssdName: (objUWGlobal.packParId != null ? objCurrPackPar.assdName : $F("globalAssdName")),
						globalParType:  (objUWGlobal.packParId != null ? objCurrPackPar.parType : $F("globalParType")),
						globalEndtPolicyNo: (objUWGlobal.packParId != null ? objCurrPackPar.endtPolicyNo : $F("globalEndtPolicyNo")),
						isPack: (objUWGlobal.packParId != null ? "Y" : "N") // added by andrew - 03.28.2011
					},
					evalScripts:	true,
					asynchronous: 	true,
					onCreate: function() {
						setCursor("wait");
						showNotice("Getting Engineering Additional Information, please wait...");
					},
					onComplete: function (response) {
						setCursor("default");
						hideNotice();
						if(checkErrorOnResponse(response)){
							Effect.Appear($("parInfoDiv").down("div", 0), {
								duration: .001
							});
						}
					}
				});
			}
		});
	} catch(e) {
		showErrorMessage("showAdditionalENInfoPage", e);
	}
}