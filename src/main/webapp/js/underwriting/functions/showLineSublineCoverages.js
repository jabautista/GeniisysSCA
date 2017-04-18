/**
 * Created By: Irwin. March 10, 2011
 * */
function showLineSublineCoverages(){
	try{
		new Ajax.Updater("parInfoDiv", contextPath+"/GIPIWPackLineSublineController",{
			method: "POST",
			parameters: {
				packParId: objUWGlobal.packParId,
				lineCd: objUWGlobal.lineCd,
				action: "showLineSublineCoverages"
			},
			evalScripts: true,
			asynchronous: true,
			onCreate: function() {
				showNotice("Getting Line and Subline coverages, please wait...");
			},
			onComplete: function () {
				hideNotice("");
				Effect.Appear($("parInfoDiv").down("div", 0), {
					duration: .001,
					afterFinish: function (){
					} 
				});
			}
		});	
	}catch(e){
		showErrorMessage("showLineSublineCoverages", e);
	}
}
