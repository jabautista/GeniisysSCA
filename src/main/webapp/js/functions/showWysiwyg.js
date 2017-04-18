//show the Wysiwyg
function showWysiwyg(textId) {
	wysiwygTempTextId = textId;
	wysiwygTemp = new nicEditor({buttonList : ['save','bold','italic','underline','ol','ul','fontSize','fontFamily','fontFormat','image','upload','link','unlink','forecolor','bgcolor']}).panelInstance(textId);
	$("btnEditRemarks").hide();
	$("btnOkRemarks").show();
}