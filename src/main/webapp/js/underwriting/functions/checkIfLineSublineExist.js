function checkIfLineSublineExist(){
	try{
		new Ajax.Request(contextPath+"/GIPIPackPARListController", {
			method: "GET",
			parameters: {action: "checkIfLineSublineExist",
						 packParId: $F("globalPackParId"),
						 packLineCd: $F("vlineCd")
						 },
			onCreate: function() {
				showNotice("Checking line and subline, please wait...");
			}, 
			onComplete: function (response)	{
				if (checkErrorOnResponse(response)) {
					var responseArr		= response.responseText.split(",");					
					//var validationFlag 	= responseArr[0];
					var message			= responseArr[0];
					var result 			= responseArr[1];
					if ("SUCCESS" == message) {
						hideNotice(message);
						//Modalbox.hide();
						if(result == 'Y'){
							hasLineSubline = 'Y';
						}
						showMessageBox("PAR has been successfully created.", imgMessage.SUCCESS);
					} else {
						showMessageBox(message, imgMessage.ERROR);
					}
				}
			}
		});
	}catch(e){
		showErrorMessage("checkIfLineSublineExist", e);
	}	
}