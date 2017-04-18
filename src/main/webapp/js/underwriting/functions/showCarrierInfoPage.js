//mrobes 03.05.10 shows Carrier Information Page
function showCarrierInfoPage() {
	try {		
		//updateParParameters();
		if (parseFloat((objUWGlobal.packParId != null ? objCurrPackPar.parStatus : $F("globalParStatus"))) < 3){
			showMessageBox("Carrier Information menu is not accessible due to this PAR's status.");
			return false;
		}		
		/*
		if ((objUWGlobal.packParId != null ? objCurrPackPar.lineCd : $F("globalLineCd")) != objLineCds.MN || (objUWGlobal.packParId != null ? objCurrPackPar.opFlag : $F("globalOpFlag")) == "Y"){
			showMessageBox("Carrier Information menu is not applicable to this PAR.");
			return;
		}*/		
		// comment out by andrew - 03.25.2011 - causing error in package par
		/*objUWGlobal.parNo 		= null;
		objUWGlobal.assdNo 		= null;
		objUWGlobal.assdName 	= null;*/
		var containerDiv = (objUWGlobal.packParId != null ? objCurrPackPar.containerDiv : "parInfoDiv"); // added by andrew - 03.28.2011
		Effect.Fade($("parInfoDiv").down("div", 0), {
			duration: .001,
			afterFinish: function() {				
				new Ajax.Updater(containerDiv, contextPath+"/GIPIWVesAirController",{
					method: "GET",
					parameters: {action:	     "showWVesAirPage",
								 refresh:    1,
								 globalParId:   (objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId")),
								 globalParNo:   (objUWGlobal.packParId != null ? objCurrPackPar.parNo : $F("globalParNo")),
								 globalAssdNo:  (objUWGlobal.packParId != null ? objUWGlobal.assdNo : $F("globalAssdNo")),
								 globalAssdName:(objUWGlobal.packParId != null ? objUWGlobal.assdName : $F("globalAssdName")),
								 //added by: nica 10.27.2010 
								 //to reused the carrier information page for endt
								 globalParType: (objUWGlobal.packParId != null ? objUWGlobal.parType :$F("globalParType")),
								 globalPolicyNo:(objUWGlobal.packParId != null ? objUWGlobal.endtPolicyNo :$F("globalEndtPolicyNo")),
								 isPack: (objUWGlobal.packParId != null ? "Y" : "N"), // added by andrew - 03.28.2011
								 lineCd: (objUWGlobal.packParId != null ? objUWGlobal.lineCd : $F("globalLineCd")), //Added by Jerome 08.31.2016 SR 5623
								 issCd: (objUWGlobal.packParId != null ? objUWGlobal.issCd : $F("globalIssCd")) //Added by Jerome 08.31.2016 SR 5623
								 },
					evalScripts: true,
					asynchronous: true,
					onCreate: function() {
						setCursor("wait");
						showNotice("Getting Carrier Information, please wait...");
					},
					onComplete: function (response) {						
						setCursor("default");
						hideNotice();
						if(checkErrorOnResponse(response)){
							Effect.Appear($("parInfoDiv").down("div", 0), { //comment out by andrew - 03.28.2011
								duration: .001
							});
						}
					}
				});			
			}
		});		
	} catch(e){
		showErrorMessage("showCarrierInfoPage", e);
	} 
}