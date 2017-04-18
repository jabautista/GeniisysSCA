// The following functions are used by GIPIS154 (Lead Policy Information) 
// Nica - May 2011
function showLeadPolicyPage(){
	if (($F("globalParId").blank()) || ($F("globalParId")== "0")) {
		showMessageBox("You are not allowed to view this page.", imgMessage.ERROR);
		return;
	} else {
		var parId   = $F("globalParId");
		var lineCd  = $F("globalLineCd");
		var parType = $F("globalParType");
		var policyNo= $F("globalEndtPolicyNo");
		
		new Ajax.Updater("parInfoDiv", contextPath+"/GIPILeadPolicyController",{
				parameters:{
					parId: parId,
					lineCd: lineCd,
					parType: parType,
					policyNo: policyNo,
					action: "showLeadPolicy"
					},
				asynchronous: true,
				evalScripts: true,
				onCreate: showNotice("Getting lead policy information, please wait..."),
				onComplete: function (response)	{
					hideNotice("");
					Effect.Appear($("parInfoDiv").down("div", 0), { 
						duration: .001,
						afterFinish: function () {
							if ($("message").innerHTML == "SUCCESS"){
								loadLeadPolicyPerilListing();
								updateParParameters();
							} else {
								showMessageBox($("message").innerHTML, imgMessage.ERROR);
							}
						}
					});
					setDocumentTitle("Lead Policy Information");
					addStyleToInputs();
					initializeAll();
				}	
		});
	}
}