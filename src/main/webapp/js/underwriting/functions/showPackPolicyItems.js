/*	Created by	: mark jm 03.16.2011
 * 	Description	: show package policy items
 */
function showPackPolicyItems(){
	try{
		// edited by: nica 07.18.2011 - added condition for endt package
		var action = objUWGlobal.parType == "E" ? "showEndtPackPolicyItems" : "showPackPolicyItems";
			
		new Ajax.Updater("parInfoDiv", contextPath+"/GIPIWItemController",{
			method: "POST",
			parameters: {
				packParId: objUWGlobal.packParId,
				lineCd: objUWGlobal.lineCd,
				action: action
			},
			evalScripts: true,
			asynchronous: true,
			onCreate: function() {
				showNotice("Getting Package Policy Items, please wait...");
			},
			onComplete: function () {
				hideNotice("");
				Effect.Appear($("parInfoDiv").down("div", 0), {
					duration: .001,
					afterFinish: function (){
						updatePackParParameters(); // added by: Nica 05.09.2012
					} 
				});
			}
		});	
	}catch(e){
		showErrorMessage("showPackPolicyItems", e);
	}
}