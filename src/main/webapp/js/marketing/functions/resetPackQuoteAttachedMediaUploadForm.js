/**
 * Resets the value of the the upload form fields for
 * attached media sub-page under Package Quotation Information
 * @return
 */

function resetPackQuoteAttachedMediaUploadForm(){
	$("file").value    = "";
	$("saveAs").value  = "";
	$("remarks").value = "";
	$("uploadForm").enable();
	enableButton("btnUploadMedia"); 				
	disableButton("btnDeleteMedia");
    $("trgID").contentWindow.document.body.innerHTML = "";
    editMode = false;
}