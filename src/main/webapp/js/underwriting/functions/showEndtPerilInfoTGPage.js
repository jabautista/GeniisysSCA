/**
 * Shows Endorsement Peril Information Page
 * @author andrew robes
 * @date 05.18.2012
 * 
 */
function showEndtPerilInfoTGPage(){
	try {		
		new Ajax.Updater("perilInformationDiv", contextPath+"/GIPIWItemPerilController", {
			method: "GET",
			parameters: {action:			"showEndtPerilInfoTG",
						 globalParType:		$F("globalParType"),
						 globalParId: 		$F("globalParId"),
						 itemNo : $F("itemNo")
						 },
			asynchronous: true,
			evalScripts: true,
			onComplete: function (response) {
				setCursor("default");
				if(checkErrorOnResponse(response)){
					
				}
			}
		});
	} catch (e) {
		showErrorMessage("showEndtPerilInfoTGPage", e);
	}
}