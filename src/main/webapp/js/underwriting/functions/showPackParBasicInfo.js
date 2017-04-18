//nica 11.09.2010
function showPackParBasicInfo(){
	try{
		getPackBasicInfo();
		/*
		new Ajax.Updater("parInfoDiv", contextPath+"/GIPIPackParInformationController",{
			parameters: {
				packParId: objUWGlobal.packParId,
				lineCd: objUWGlobal.lineCd,
				issCd: objUWGlobal.issCd,
				action: "showPackParBasicInfo"
			},
			asynchronous: true,
			evalScripts: true,
			onCreate: function(){
				showNotice("Getting Package PAR Basic Information, please wait...");
			},
			onComplete:function(response){
				hideNotice("");
				if(checkErrorOnResponse(response)){
					Effect.Fade("packParListingTableGridMainDiv",{
						duration: 0.001,
						afterFinish: function(){
							$("parInfoMenu").show();
							Effect.Appear("parInfoDiv",{
								duration: 0.001,
								afterFinish: function(){
									if ($("message").innerHTML == "SUCCESS"){
										updatePackParParameters();
										initializeMenu();
									} else {
										showMessageBox($("message").innerHTML, imgMessage.ERROR);
										//$("basicInformationForm").disable();
										//$("basicInformationFormButton").disable();
									}
								}
							});
					   }
					});
				}
			}
		});	*/
	}catch(e){
		showErrorMessage("showPackParBasicInfo", e);
	}
}