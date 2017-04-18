/**
 * Initiate search in DirectClaimPayments modalBox search
 * 
 * @param modalPageNo
 * @param keyword
 * @return
 */
function searchAdviceNumberModal(modalPageNo, keyword) {
	new Ajax.Updater('searchResult',
			'GIACDirectClaimPaymentController?action=getAdviceSequenceListing&pageNo='
					+ modalPageNo + '&keyword=' + keyword, {
				asynchronous : true,
				evalScripts : true,
				onCreate : function() {
					showLoading('searchResult', 'Getting list please wait...',
							"120px");
				}
			});
}