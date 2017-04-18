/** 
 * Load individual attached media of selected itemNo
 * @param itemNo
 * @author rencela
 * @return
 */
function loadAttachedMediaAccordion(itemNo) {
	//var params = "FileUploadController?action=showAttachedMediaPage&quoteId=" + $("mainContents").down("input", 0).value + "&itemNo=";
	var params = "FileUploadController?action=showAttachedMediaPage&quoteId=" + $F("quoteId") + "&itemNo=";
	$("attachedMediaMotherDiv").childElements().each(function(children){children.hide();});
	new Ajax.Updater("attachedMediaMotherDiv", params + itemNo, {
		asynchronous : true,
		evalScripts : true,
		method : "GET",
		insertion : "bottom",
		onComplete : function() {
			Effect.BlindDown("attachedMediaMotherDiv", {duration: .3});
			enableQuotationMainButtons();
			showAccordionLabelsOnQuotationMain();
		}
	});
}