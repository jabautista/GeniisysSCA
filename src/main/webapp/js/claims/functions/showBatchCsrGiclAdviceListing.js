/**
 * Shows the tableGrid listing of GICLAdvice for GICLS043
 * @param insertTag
 * @param batchCsrId
 * @author Veronica V. Raymundo
 */
function showBatchCsrGiclAdviceListing(insertTag, batchCsrId){
	try{
		new Ajax.Updater("giclAdviceListTableGridDiv", contextPath + "/GICLAdviceController?action=showGicls043AdviceListing", {
			asynchrous: true,
			evalScripts: true,
			parameters:{
				insertTag: nvl(insertTag,0),
				batchCsrId: nvl(batchCsrId, 0),
				ajax: 1
			},
			onCreate : function() {
				showNotice("Loading, please wait...");
			},
			onComplete: function (response){
				hideNotice("");
			}
		});
	}catch(e){
		showErrorMessage("showBatchCsrGiclAdviceListing", e);
	}
}