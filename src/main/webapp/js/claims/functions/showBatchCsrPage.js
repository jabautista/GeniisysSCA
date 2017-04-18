/**
 * Shows the main page of the Batch Claim Settlement Page
 * @param insertTag
 * @param batchCsrId
 * @author Veronica V. Raymundo
 */
function showBatchCsrPage(insertTag, batchCsrId){
	try{
		new Ajax.Updater("batchCsrDiv", contextPath + "/GICLBatchCsrController?action=showBatchCsrPage", {
			asynchrous: true,
			evalScripts: true,
			parameters:{
				insertTag: nvl(insertTag,0),
				batchCsrId: nvl(batchCsrId, 0)
			},
			onCreate : function() {
				showNotice("Loading, please wait...");
			},
			onComplete: function (response){
				hideNotice("");
				Effect.Fade("batchCsrListingMainDiv", {
					duration: .001,
					afterFinish: function () {
						Effect.Appear("batchCsrDiv", {				
							duration: .001
						});
					}
				});
			}
		});
	}catch(e){
		showErrorMessage("showBatchCsrPage", e);
	}
}