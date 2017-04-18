/**
 * Shows Create RI Placement
 * Module: GIRIS002 - Enter RI Acceptance 
 * @author D.Alcantara
 */
function showEnterRIAcceptancePage() {
	try {
		if (nvl(objRiFrps.lineCd,null) == null 
				&& nvl(objRiFrps.frpsYy,null) == null 
				&& nvl(objRiFrps.frpsSeqNo,null) == null){
			if ($("lblModuleId").getAttribute("moduleid") != "GIRIS006"){

			}else{
				//comment out by Rod. 05/04/2012
				//showMessageBox("Please select any record first.", "I");
				
				//Added by Rod. 05/04/2012
				showMessageBox("Please select FRPS first.", "I");
				return false;
			}	
		}	
		//var loadFromMenu = nvl(loadFromUWMenu, null) == null ? "Y" : loadFromUWMenu;
		Effect.Fade($("mainContents").down("div", 0), {
			duration: .001,
			afterFinish: function() {
				new Ajax.Updater("mainContents",contextPath+"/GIRIWFrpsRiController",{
					parameters:{
						action: "showEnterRIAcceptancePage",
						loadFromUWMenu : nvl(riAcceptSearch, null) == null ? "Y" : riAcceptSearch,
						lineCd : objRiFrps.lineCd,
						frpsYy : objRiFrps.frpsYy,
						frpsSeqNo : objRiFrps.frpsSeqNo,
						riSeqNo : objRiFrps.riSeqNo
						//riSeqNo : loadFromMenu == "Y" ? "" : objRiFrps.riSeqNo
					},
					asychronous: false,
					evalScripts: true,
					onCreate: showNotice("Loading Enter RI Acceptance, please wait..."),
					onComplete: function(response){
						if (checkErrorOnResponse(response)){
							hideNotice("");
							initializeMenu();
							setModuleId("GIRIS002");
							objRiFrps.loadFromGIRIS002 = "Y";	//Gzelle 10.21.2013
							Effect.Appear($("mainContents").down("div", 0), {duration: .001}); //"mainContents"
						}	
					}	
				});
			}
		});
	} catch(e) {
		showErrorMessage("showEnterRIAcceptancePage", e);
	}
}