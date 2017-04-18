/**
 * Shows Package Renewal/Replacement Detail modal
 * Module: GIPIS002A - Package PAR Basic Information
 * @author Veronica V. Raymundo
 * 
 */

function openPackageRenewalReplacementDetailModal(){
	try {
		new Ajax.Updater("policyRenewalDiv", contextPath+"/GIPIPackWPolnrepController", {
			method: "GET",
			asynchronous: true,
			evalScripts: true,
			parameters: {packParId:  	  objUWGlobal.packParId,
						 lineCd:    	  objUWGlobal.lineCd,
						 sublineCd: 	  nvl(objUWGlobal.sublineCd, $F("sublineCd")),
						 issCd:	  		  objUWGlobal.issCd,
						 action:		  "showPackRenewalPage"},
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
		showErrorMessage("openPackageRenewalReplacementDetailModal", e);
	}
}