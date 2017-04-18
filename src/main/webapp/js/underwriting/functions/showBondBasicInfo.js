//jerome 03.16.10 for bond basic information
function showBondBasicInfo(){
	updateParParameters(); // added by: nica 02.07.2011
	if (($F("globalParId").blank()) || ($F("globalParId")== "0")) {
		showMessageBox("You are not allowed to view this page.", imgMessage.ERROR);
		return;
	} else if ($F("globalLineCd") != "SU" && objUWGlobal.menuLineCd != "SU"){ //added by steven 10.11.2014
		showMessageBox("You are not allowed to view this page.", imgMessage.ERROR);
		return;
	} 	
	var parId = $F("globalParId");
	var lineCd = $F("globalLineCd");
	var issCd = $F("globalIssCd");
	new Ajax.Updater("parInfoDiv", contextPath+"/GIPIParBondInformationController", {
		parameters:{
			parId: parId,
			lineCd: lineCd,
			issCd: issCd,
			action: "showBondBasicInfo"
		},
		evalScripts: true,
		asynchronous: true,
		onCreate: function () {
			showNotice("Getting Bond Basic Information, please wait...");
		},
		onComplete: function () {
			hideNotice("");
			if ($("parListingMainDiv").getAttribute("module") == "parCreation"){ //nok 
				//Effect.Fade("parCreationMainDiv", {duration: .001});
				$("parCreationMainDiv").update(""); //nok
			}
			Effect.Fade("parListingMainDiv", {
				duration: .001,
				afterFinish: function () {
					$("parInfoMenu").show();
					Effect.Appear("parInfoDiv", { //bondBasicInformationMainDiv
						duration: .001,
						afterFinish: function () {
							if ($("message").innerHTML == "SUCCESS" ){
								initializeMenu();
								//updateParParameters(); commented by: nica 02.07.2011
								$("sublineCd").focus();
								$("samplePolicy").innerHTML = "Sample Policy";
							} else{
								showMessageBox($("message").innerHTML, imgMessage.ERROR);
								$("basicInformationForm").disable();
								$("basicInformationFormButton").disable();
							}
						}
					});
				}
			});
		}	
	});	
}