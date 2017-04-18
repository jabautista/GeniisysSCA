/**
 * shows package carrier information page
 * @author andrew robes
 * @date 03.28.2011 
 */
function showPackCarrierInformation(packParId, packLineCd){
	try {
		new Ajax.Request(contextPath+"/GIPIWVesAirController",{
			parameters : {
				action : "showPackCarrierInfoPage",
				globalParType:  objUWGlobal.parType,
				globalPackParNo:objUWGlobal.parNo,
				globalAssdNo:   objUWGlobal.assdNo,
				globalAssdName: objUWGlobal.assdName,
				packParId : packParId,
				packLineCd : packLineCd
			},
			asynchronous: true,
			evalScripts: true,
			onCreate: function() {
				showNotice("Getting package carrier information, please wait...");
			},
			onComplete: function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					$("parInfoDiv").update(response.responseText);
				}
			}
		});	
	} catch (e){
		showErrorMessage("showPackCarrierInformation", e);
	}
}