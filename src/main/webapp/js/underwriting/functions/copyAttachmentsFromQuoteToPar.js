/**
 *  Copy attachments from Quotation to PAR.
 *  @date DEC-14-2016
 *  @param row - Selected record from Quotation LOV.
 */

function copyAttachmentsFromQuoteToPar(row) {
	new Ajax.Request(contextPath + "/GIPIPARListController", {
		method: "POST",
		parameters: {
			action: "copyAttachmentsFromQuoteToPar",
			quoteId: row.quoteId,
			lineCd: row.lineCd,
			parId: $F("globalParId"),
			parNo: $F("globalParNo").replace(/\s/g, '')
		},
		onComplete: function(response) {
			if(! checkErrorOnResponse(response)){
				showMessageBox(response.responseText, imgMessage.ERROR);
			}
		}
	});
}
