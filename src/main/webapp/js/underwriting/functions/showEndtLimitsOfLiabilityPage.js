/**
 * Enter Cargo Limit of Liability Endorsement Information
 * Module: GIPIS078
 * @author Marco Paolo Rebong
 */
function showEndtLimitsOfLiabilityPage(){
	try{
		new Ajax.Updater("parInfoDiv", contextPath+"/GIPIWOpenLiabController",{
			parameters: {
				action: "showEndtLimitsOfLiabilityPage",
				globalParId: nvl($F("globalParId"), objUWGlobal.parId)
			},
			method: "GET",
			evalScripts: true,
			asynchronous: true,
			onCreate: function(){
				setCursor("wait");
				showNotice("Loading Cargo Limits of Liability, please wait...");
			},
			onComplete: function() {
				changeTag = 0;
				setCursor("default");
				hideNotice("");
				setModuleId("GIPIS078");
				setDocumentTitle("Endorsement - Enter Limits and Liabilities");
				Effect.Appear($("parInfoDiv").down("div", 0), {
					duration: .001,
					afterFinish: function (){
						$("parNo").focus();
						updateParParameters();
						setParMenus(parseInt($F("globalParStatus")), $F("globalLineCd"), $F("globalSublineCd"), $F("globalOpFlag"), $F("globalIssCd"));
						initializeMenu();
					}
				});
			}
		});
	}catch(e){
		showErrorMessage("showEndtLimitsOfLiabilityPage",e);
	}
}