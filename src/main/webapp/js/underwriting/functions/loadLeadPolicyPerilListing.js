function loadLeadPolicyPerilListing(){
	new Ajax.Updater("leadPolicyPerilDiv1", contextPath+"/GIPILeadPolicyController",{
		parameters: {
			parId: $F("globalParId"),
			itemNo: $F("selectedItemNo"),
			action: "showLeadPolicyPerilListing"
		},
		asynchronous: true,
		evalScripts: true,
		onCreate: showNotice("Loading lead policy peril listing..."),
		onComplete: function(response){
			hideNotice();
			if(checkErrorOnResponse(response)){

			}else{
				showMessageBox(response.responseText, imgMessage.ERROR);
			}
		}
	});
}