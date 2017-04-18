//mrobes 03.10.10 get Cargo Class list
function getCargoClass(){
	try {
		new Ajax.Updater("cargoClassDivAndFormDiv", contextPath+"/GIPIWOpenCargoController",{
			method: "GET",
			parameters: {action:	     "getCargoClass",
						 globalParId:    $F("globalParId"),
						 geogCd:		 $F("inputGeography")
						 },
			evalScripts: true,
			asynchronous: true,
			//onCreate: showNotice("Getting cargo class..."),
			onComplete: function (response) {
				//hideNotice();
				//checkErrorOnResponse(response);
				if (checkErrorOnResponse(response)){
					getOpenPeril();
				}
			}
		});
	} catch(e){
		showErrorMessage("getCargoClass", e);
/*		if("element is null" == e.message){
			showMessageBox("Some parameters needed to get Cargo Classes is missing.");
		} else {
			showMessageBox("getCargoClass : " + e.message);
		}*/
	}	
}