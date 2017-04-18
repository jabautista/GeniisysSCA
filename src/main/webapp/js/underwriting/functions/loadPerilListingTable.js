function loadPerilListingTable(){
	try {
		var parId = (objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId")); // andrew
		new Ajax.Updater("perilInformation", contextPath+"/GIPIWItemPerilController?action=loadItemPerilTable&globalParId="+parId,{ //+"&"+Form.serialize("uwParParametersDiv"), { // comment out by andrew
			asynchronous: true,
			evalScripts: true,
			method: "GET",
			onCreate : function(){
				//showNotice("Getting Peril listings, please wait...");
			}, 
			//onCreate: showNotice("Getting Peril listings, please wait..."),
			onComplete: function () {
				hidePerilInfoDiv();
				initializeAllMoneyFields();
				//hideNotice();
			}
		});
	} catch(e){
		showErrorMessage("loadPerilListingTable", e);
	}
}