//mrobes 03.09.10 shows Limits of Liability Page
/* MODE LEGEND:
 *   0 = Without Cargo
 *   1 = With Cargo
 */
function showLimitsOfLiabilityPage(mode){
	try {		
		if (parseFloat($F("globalParStatus")) < 3){
			showMessageBox((mode == 1 ? "Cargo Limits of Liability" : "Limits of Liabilities") + " menu is not accesible due to this PAR's status.");
			return false;				
		}		
		/*
		if (mode == 1){
			if ((objUWGlobal.lineCd != objLineCds.MN || objUWGlobal.menuLineCd != objLineCds.MN) && $F("globalOpFlag") != 'Y'){
				showMessageBox("Cargo Limits of Liability menu is not applicable to this PAR.");
				return;
			} 		
		} else if (mode == 0){
			if ((objUWGlobal.lineCd != objLineCds.AC || objUWGlobal.menuLineCd != objLineCds.AC) || $F("globalOpFlag") != 'Y') {
				showMessageBox("Limits of Liabilities menu is not applicable to this PAR.");
				return;
			}
		}*/		
		//updateParParameters();
		Effect.Fade($("parInfoDiv").down("div", 0), {
			duration: .001,
			beforeFinish: function () {
				new Ajax.Updater("parInfoDiv", contextPath+"/GIPIWOpenLiabController",{
					method: "GET",
					parameters: {action:	      "showLimitsOfLiabilityPage",
								 globalParId:     $F("globalParId"),
								 globalLineCd:    $F("globalLineCd"),
								 globalSublineCd: $F("globalSublineCd"),
								 globalParNo:     $F("globalParNo"),
								 globalAssdNo:    $F("globalAssdNo"),
								 globalAssdName:  $F("globalAssdName"),
								 mode:			  mode
								 },
					evalScripts: true,
					//asynchronous: false,
					onCreate: function() {
						setCursor("wait");
						showNotice("Getting " + (mode == 1 ? "Cargo" : "") + " Limits of Liabilities, please wait...");
					},
					onComplete: function (response) {
						//hideNotice();
						
						/*if (checkErrorOnResponse(response)){
							if (mode == 1){					
								getCargoClass();
							} else {
								getOpenPeril();
							}
						}*/
						setCursor("default");
						hideNotice();
						Effect.Appear($("parInfoDiv").down("div", 0), {//liabilityMainDiv
							duration: .001
						});		
					}
				});
			}
		});
	} catch(e){
		showErrorMessage("showLimitsOfLiabilityPage", e);
	}
}