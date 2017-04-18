/*
 * Shows Bill No List for Comm Payts Emman Oct 5, 2010
 */
function searchGcopInvDetails(pageNumber) {
	new Ajax.Updater("searchResult",
			"GIACCommPaytsController?action=getGcopInvListing", {
				onCreate : function() {
					showLoading("searchResult", "Getting list, please wait...",
							"100px");
				},
				onException : function() {
					showFailure('searchResult');
				},
				parameters : {
					pageNo : pageNumber,
					tranType : $F("txtTranType"),
					issCd : $F("txtIssCd"),
					premSeqNo : $F("txtPremSeqNo"),
					intmNo : $F("txtIntmNo"),
					intmName : $F("txtDspIntmName"),
					varVFromSums : $F("varVFromSums"),
					keyword : $F("keyword"),
					gaccTranId:		objACGlobal.gaccTranId,	// shan 10.03.2014
					notIn:	objGIACS020.notIn == null ? "--" : "(" + objGIACS020.notIn + ")",
					onLOV:	objGIACS020.onLOV
				},
				asynchronous : true,
				evalScripts : true
			});
}