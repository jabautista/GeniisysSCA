//mrobes 03.10.10 get Open Peril list
function getOpenPeril(){
	try {
		new Ajax.Updater("perilDivAndFormDiv", contextPath+"/GIPIWOpenPerilController",{
			method: "GET",
			parameters: {action:	     "getOpenPeril",
						 globalParId:    $F("globalParId"),
						 globalLineCd:	 $F("globalLineCd"),
						 geogCd:		 $F("inputGeography")
						 },
			evalScripts: true,
			asynchronous: true,
			//onCreate: function(){
				//showLoading("Getting perils...");
			//},
			onComplete: function (response) {
				setCursor("default");
				hideNotice();
				if (checkErrorOnResponse(response)) {
					Effect.Appear($("parInfoDiv").down("div", 0), {//liabilityMainDiv
						duration: .001
					});																						
				}
			}
		});
	} catch(e){
		showErrorMessage("getOpenPeril", e);
/*		if("element is null" == e.message){
			showMessageBox("Some parameters needed to view Open Perils is missing.");
		} else {
			showMessageBox("getOpenPeril : " + e.message);
		}*/
	}	
}