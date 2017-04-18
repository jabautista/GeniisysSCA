//hide the Wysiwyg
function hideWysiwyg() {
	wysiwygTemp.removeInstance(wysiwygTempTextId);
	wysiwygTemp = null;
	wysiwygTempTextId = null;
	$("btnEditRemarks").show();
	$("btnOkRemarks").hide();
}