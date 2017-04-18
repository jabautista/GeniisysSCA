/**
 * Call ajax result modal page for Recovery No. Loss Recovery in module GIACS010
 * 
 * @author Jerome Orio 10.06.2010
 * @version 1.0
 * @param modalPageNo -
 *            page no. of record keyword - keyword about to search
 * @return
 */
function searchRecoveryNoModal(modalPageNo, keyword) {
	new Ajax.Updater('searchResult',
			'GIACLossRecoveriesController?action=searchRecoveryNoModal&pageNo='
					+ modalPageNo + '&keyword=' + encodeURIComponent(keyword),
			{ // marco - 05.10.2013 - encode
				parameters : {
					transactionType : $F("selTransactionTypeLossRec"),
					lineCd: $F("txtLineCdLossRec"), //marco - 09.30.2014 - added filter parameters
					issCd: $F("txtIssCdLossRec"),
					recYear: $F("txtRecYearLossRec"),
					recSeqNo: $F("txtRecSeqNoLossRec")
				},
				asynchronous : false,
				evalScripts : true,
				onCreate : function() {
					showLoading('searchResult', 'Getting list, please wait...',
							"120px");
				}
			});
}