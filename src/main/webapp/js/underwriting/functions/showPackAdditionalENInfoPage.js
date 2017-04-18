/**
 * shows package additional engineering information page
 * @author andrew robes
 * @date 03.28.2011 
 */
function showPackAdditionalENInfoPage(packParId, packLineCd){
	try {
		new Ajax.Request(contextPath+"/GIPIWENAdditionalInfoController",{
			parameters : {
				action : "showPackAdditionalENInfoPage",
				globalParType:  objUWGlobal.parType,
				globalPackParNo:objUWGlobal.parNo,
				globalAssdNo:   objUWGlobal.assdNo,
				globalAssdName: objUWGlobal.assdName,
				globalParId : packParId,
				packParId : packParId,
				packLineCd : packLineCd
			},
			asynchronous: true,
			evalScripts: true,
			onCreate: function() {
				showNotice("Getting package additional engineering information, please wait...");
			},
			onComplete: function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					$("parInfoDiv").update(response.responseText);
				}
			}
		});	
	} catch (e){
		showErrorMessage("showPackAdditionalENInfoPage", e);
	}
}