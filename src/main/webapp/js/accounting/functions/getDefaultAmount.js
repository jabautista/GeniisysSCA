/**
 * Get default collection amount on Collections For Other Offices Module
 * GIACS012
 * 
 * @author Nica Raymundo 12.15.2010
 * @return
 */
function getDefaultAmount() {
	new Ajax.Request(contextPath
			+ "/GIACCollnsForOtherOfficeController?action=getDefaultAmount", {
		evalScripts : true,
		asynchronous : false,
		method : "GET",
		parameters : {
			tranYear : $F("tranYear"),
			tranMonth : $F("tranMonth"),
			tranSeqNo : $F("tranSeqNo"),
			gibrGfunFund : $F("oldFundCode"),
			gofcGibrBranch : $F("oldBranch"),
			gofcItemNo : $F("oldItemNo")
		},
		onComplete : function(response) {
			if (checkErrorOnResponse(response)) {
				var obj = response.responseText.evalJSON();
				if (obj.message == "SUCCESS") {
					validateDefaultAmount(obj.collnAmt, obj.gaccTranId);
				} else {
					showMessageBox(obj.message, imgMessage.INFO);
					resetTransFields();
				}
			}
		}
	});
}