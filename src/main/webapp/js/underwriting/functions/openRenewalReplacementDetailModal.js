//mrobes 01.04.10 shows Policy - Renewal/Replacement Detail modal
function openRenewalReplacementDetailModal(){
	try {
		new Ajax.Updater("policyRenewalDiv", contextPath+"/GIPIWPolnrepController", {
			method: "GET",
			asynchronous: true,
			evalScripts: true,
			parameters: {globalParId:  	  $F("globalParId"),
						 globalLineCd:    $F("globalLineCd"),
						 globalSublineCd: $F("sublineCd"),
						 globalIssCd:	  $F("globalIssCd"),
						 action:		  "showWRenewalPage"},
			onCreate: function (){
					setCursor("wait");
					showSubPageLoading("showRenewal", true);
					showNotice("Retrieving renewal/replacement detail, please wait...");
				},
			onComplete: function (response){
					checkErrorOnResponse(response);
					setCursor("default");
					showSubPageLoading("showRenewal", false);
					hideNotice("");
				}			
		});
	} catch(e){
		showErrorMessage("openRenewalReplacementDetailModal", e);
		/*if("element is null" == e.message){
			showMessageBox("Some parameters needed to open Renewal/Replacement Detail is missing.", imgMessage.ERROR);
		} else {
			showMessageBox(e.message, imgMessage.ERROR);
		}*/
	}
}