// added by shan 10.21.2013
function checkCoInsurerInfo(){
	try{
		new Ajax.Request(contextPath+"/GIPILeadPolicyController",{
			method: "POST",
			parameters: {
				action:				"limitEntry",
				globalPackParId:	objUWGlobal.packParId,
				parId:				$F("globalParId")
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: showNotice("Checking Co-Insurer Information..."),
			onComplete: function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					if (response.responseText == "GIPIS153"){
						showWaitingMessageBox("Please enter your CO-INSURER information for this PAR.", 
								imgMessage.INFO, showCoInsurerPage);
					}else{
						showLeadPolicyPage();
					}
				}
			}
		});
	}catch(e){
		showMessageBox("checkCoInsurerInfo", e);
	}
}