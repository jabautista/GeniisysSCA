function loadCosignorsListingTable(){
	if ("N" == $F("cosignorIsLoaded")){
		new Ajax.Updater("cosignorsListingTableDiv", contextPath+"/GIPIWCosignatoryController?action=loadCosignorsListingTable&"+Form.serialize("uwParParametersForm"),{
			method:"GET",
			evalScripts: true,
			asynchronous: true,
			//onCreate: showNotice("Getting cosignors listing, please wait..."),
			onComplete: function () {
				$("bondMainDiv").show();
				//hideNotice("");
				$("cosignorIsLoaded").value = "Y";
			}
		});
	}
}