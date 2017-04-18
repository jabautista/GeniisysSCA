/**
 * Shows Enter Spoiled O.R. page
 * @author andrew robes
 * @date 04.06.2011
 */
function showEnterSpoiledOR(){
	try {
		new Ajax.Request(contextPath+"/GIACSpoiledOrController", {
			method: "GET",
			evalScripts: true,
			parameters: {action: "showEnterSpoiledOR"},
			onCreate: showNotice("Getting Spoil Official Receipt page, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					$("acExit").show(); // added by andrew - 02.18.2011
					$("mainContents").update(response.responseText);
					hideAccountingMainMenus();
				}
			}
		});
	} catch (e) {
		showErrorMessage("showEnterSpoiledOR", e);
	}	
}