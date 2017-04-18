/**
 * Endorsement - Limits of Liability Data Entry
 * Module Id: GIPIS173
 * @author Marie Kris Felipe
 * */
function showEndtLimitsOfLiabilityDataEntry(){
	try {
		new Ajax.Updater("parInfoDiv", contextPath+"/GIPIWOpenLiabController",{
			parameters:{
				action: "showEndtLimitsOfLiabilityDataEntry",
				globalParId: nvl($F("globalParId"), objUWGlobal.parId)
			},
			method: "GET",
			evalScripts: true,
			asynchronous: true,
			onCreate: function(){
				setCursor("wait");
				showNotice("Loading Endorsement Limits of Liablity, please wait...");
			},
			onComplete: function(){
				setCursor("default");
				changeTag = 0;
				hideNotice("");
				Effect.Appear($("parInfoDiv").down("div", 0), {
					duration: .001,
					afterFinish: function(){
						$("parNo").focus();
						updateParParameters();
						setParMenus(parseInt($F("globalParStatus")), $F("globalLineCd"), $F("globalSublineCd"), $F("globalOpFlag"), $F("globalIssCd"));
						initializeMenu();
					}
				}); 
			}
		});
	} catch (e){
		showErrorMessage("showEndtLimitsOfLiabilityDataEntry", e);
	}
}