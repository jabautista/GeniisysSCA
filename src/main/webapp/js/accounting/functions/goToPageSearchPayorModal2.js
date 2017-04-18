function goToPageSearchPayorModal2(elem) {
	modalPageNo2 = elem.value;
	new Ajax.Updater(
			'searchResult',
			'GIACOrderOfPaymentController?action=getPayorListing&pageNo='
					+ modalPageNo2,
			{
				onCreate : function() {
					showLoading('searchResult', 'Getting list, please wait...');
				},
				onException : function() {
					showFailure('searchResult');
				},
				asynchronous : true,
				evalScripts : true
			});
}