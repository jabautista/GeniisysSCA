/**
 * @author Veronica V. Raymundo
 * Same as openAttachMediaModal but for viewing purposes only
 * uploading of files is not allowed
 * @param uploadMode
 */
function viewAttachMediaModal(uploadMode){
	try {
		var id = getGenericId(uploadMode);
		
		Modalbox.show(contextPath+"/FileController", {
			method: "GET",
			title: "View Attached Media",
			width: 525,
			params: {genericId:  id,
					 itemNo: 	 $("itemNo") ? $F("itemNo") :$F("txtItemNo"),
					 uploadMode: uploadMode,
					 action: 	 "viewAttachMediaPage"},
			beforeHide: function () {
				$("forDeletionDiv").update("");
				deleteUpload(uploadMode);
			},
			afterHide: function () {
				if (updater != undefined) {
					updater.stop();
				}				
				new Ajax.Request(contextPath+"/FileController?action=deleteFilesFromServer", {
					asynchronous: true,
					evalScripts: true
				});
			}
		});
	} catch (e) {
		showErrorMessage("openAttachMediaModal", e);
	}
}