/**
 * Shows Purge Extract Table Page
 * Module: GIEXS003- Purge Extract Table
 * @author Marco Paolo Rebong
 */
function showPurgeExtractTablePage(){
	try{
		new Ajax.Updater("mainContents", contextPath+"/GIEXExpiriesVController?action=getPurgeExtractTable",{
			method: "GET",
			evalScripts: true,
			asynchronous: true,
			onCreate: showNotice("Loading Purge Extract Table, please wait..."),
			onComplete: function() {
				hideNotice("");
				Effect.Appear($("mainContents").down("div", 0), {duration: .001});
			}
		});
	}catch(e){
		showErrorMessage("showPurgeExtractTablePage",e);
	}
}