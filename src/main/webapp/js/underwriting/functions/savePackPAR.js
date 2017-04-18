function savePackPAR(packParType, parameters) {// added parameters for line/subline - irwin
	try{
		new Ajax.Updater("uwParParametersDiv", contextPath+"/GIPIPackPARListController?action=savePackPar&parameters="+encodeURIComponent(parameters), {// Nica 05.16.2012 - added encodeURIComponent to handle special characters
			method: "POST",
			evalScripts: true,
			asynchronous: false,
			postBody: Form.serialize("createPackPARForm"),
			onCreate: function() {
				showNotice("Saving Package PAR, please wait...");
				$("createPackPARForm").disable();
			},
			onComplete: function (response) {
				if (checkErrorOnResponse(response)) {
						$("createPackPARForm").enable();
						updatePackParParameters();
						if(packParType == "E"){
							getEndtPackParSeqNo();
						}else{
							getPackParSeqNo2();
							saved = 'Y';
							$("alreadySaved").value = 'Y';
					 		changeTag = 0;
						}
						
						hideNotice("Saving successful.");
						// edited by d.alcantara, 01-20 to initialize menu once after saving the created package
						if($F("basicEnabled") != "Y") initializePackPARBasicMenu(packParType, objUWGlobal.lineCd);
						$("basicEnabled").value = 'Y';
				}else{
					showMessageBox(response.responseText, imgMessage.ERROR);
					$("createPackPARForm").enable();
				}
				
			}
		});
	}catch(e){
		showErrorMessage("savePackPAR", e);
	}
	
	// the following code is unused yet because di pa raw na-attach ung para sa Select Quotation
	/*if (!($F("quoteId").blank())) {
		var wPackCreationProgress = new Ajax.PeriodicalUpdater("notice", contextPath+"/GIPIPackPARListController", {
			method: "GET",
			parameters: {
				action: "checkParListWPackCreationProgress"
			},
			onSuccess: function (response) {
				$("notice").update(response.responseText);
				if (response.responseText.include("success") || "" == response.responseText.trim()) {
					hideNotice(response.responseText);
					getPackParSeqNo();
					wPackCreationProgress.stop();
				}
				$("createPackPARForm").enable();
			}
	});
	}*/
	// end of unused
}