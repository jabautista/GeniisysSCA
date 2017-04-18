function showPolicyPrintingPage(){
	try {
		new Ajax.Updater("parInfoDiv", contextPath+"/PrintPolicyController?action=showPolicyPrintingPage",{
			method:"GET",
			evalScripts:true,
			asynchronous: true,
			parameters: {
				globalParId: 		(objUWGlobal.packParId != null ? null : $F("globalParId")),
				globalPackParId: 	(objUWParList.parType == "E" && objUWParList.packParId != null ? objUWParList.packParId : $F("globalPackParId")), //added by steven 9/11/2012 to handle zero globalPackParId if the package PAR is endorsement
				//globalLineCd:		nvl($F("globalLineCd"), objUWGlobal.lineCd) //marco - 11.19.2012 - for "print premium details"
			},
			onCreate: showNotice("Getting Policy Printing page, please wait..."),
			onComplete: function () {
				try {
					hideNotice("");
					//Effect.Appear($("parInfoDiv").down("div", 0), {duration: .001}); //"mainContents"
					setDocumentTitle("Generate Policy Documents");
				} catch (e){
					showErrorMessage("showPolicyPrintingPage - onComplete", e);
				}
			}
		});
	} catch (e){
		showErrorMessage("showPolicyPrintingPage", e);
	}
}