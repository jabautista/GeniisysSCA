/**
 * Shows package items page per line
 * @author andrew robes
 * @date 03.16.2011
 * @param packParId - id of package par
 * 		  packLineCd - line code of the selected menu
 */
function showPackItemsPerLine(packParId, packLineCd){
	try {
		new Ajax.Request(contextPath+"/GIPIWItemController",{
			parameters : {
				action : "showPackItemsPerLine",
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
				showNotice("Getting package item information, please wait...");
			},
			onComplete: function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					$("parInfoDiv").update(response.responseText);
				}
			}
		});		
	} catch(e){
		showErrorMessage("showPackParItemInfo", e);
	}
}