/**
 * Show RI Pack Par Creation
 * @author Irwin Tabisora
 * @date  5.28.2012
 * 
 */

function showRIPackParCreationPage(mode, parType) {
	//mode = 0 -> load from policy par creation; mode = 1 -> load from initial acceptance at basicinfomenu
	var passparams = mode == "0" ? mode : (mode+"&packParId="+$F("globalPackParId"));
	var replaceDiv = mode == "0" ? "mainContents" : "parInfoDiv";
	Effect.Fade($(replaceDiv).down("div", 0), {
		duration: .001,
		afterFinish: function() {
			new Ajax.Updater(replaceDiv, contextPath+"/GIPIPackPARListController?action=showRIPackParCreationPage&mode="+passparams+"&parType="+parType,{
				method:"GET",
				evalScripts:true,
				asynchronous: true,
				onCreate: showNotice("Getting PAR Creation page, please wait..."),
				onComplete: function () {
					hideNotice("");
					$("parTypeFlag").value = parType;
					initializeMenu();
					
					
					Effect.Appear($(replaceDiv).down("div", 0), {
						duration: .001
					});
					setDocumentTitle("Enter Package Initial Acceptance");
				}
			});
		}
	});
}