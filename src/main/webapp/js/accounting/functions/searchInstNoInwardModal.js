/**
 * Display the Installment No. Listing in Inward Facultative Premium Collections
 * 
 * @author Jerome Orio 09.02.2010
 * @version 1.0
 * @param modalPageNo
 * @param keyword
 * @return
 */
function searchInstNoInwardModal(modalPageNo, keyword) {
	var a180RiCd;
	if ($F("transactionTypeInw") == "2" || $F("transactionTypeInw") == "4") {
		a180RiCd = $("a180RiCdInw").value;
	} else {
		a180RiCd = $("a180RiCd2Inw").value;
	}
	new Ajax.Updater('searchResult',
			'GIACInwFaculPremCollnsController?action=getInstNoInwardListing&pageNo='
					+ modalPageNo + '&keyword=' + keyword, {
				parameters : {
					a180RiCd : a180RiCd,
					b140IssCd : $("b140IssCdInw").value,
					transactionType : $("transactionTypeInw").value,
					b140PremSeqNoInw : $("b140PremSeqNoInw").value
				},
				onCreate : function() {
					showLoading('searchResult', 'Getting list, please wait...',
							"120px");
				},
				asynchronous : false,
				evalScripts : true
			});
}