/**
 * Call ajax result modal page for Loss Advice in Loss Recov from RI (GIACS009)
 * 
 * @author Jerome Orio 10.22.2010
 * @version 1.0
 * @param modalPageNo -
 *            page no. of record keyword - keyword about to search
 * @return
 */
function searchLossAdviceModal(modalPageNo, keyword) {
	new Ajax.Updater('searchResult',
			'GIACLossRiCollnsController?action=searchLossAdviceModal&pageNo='
					+ modalPageNo + '&keyword=' + keyword, {
				parameters : {
					transactionType : $F("selTransactionTypeLossesRecov"),
					shareType : $F("selShareTypeLossesRecov"),
					a180RiCd : $F(objAC.hidObjGIACS009.hidCurrReinsurer),
					e150LineCd : $F("txtE150LineCdLossesRecov"),
					e150LaYy : $F("txtE150LaYyLossesRecov"),
					e150FlaSeqNo : $F("txtE150FlaSeqNoLossesRecov")
				},
				asynchronous : false,
				evalScripts : true,
				onCreate : function() {
					showLoading('searchResult', 'Getting list, please wait...',
							"120px");
				}
			});
}