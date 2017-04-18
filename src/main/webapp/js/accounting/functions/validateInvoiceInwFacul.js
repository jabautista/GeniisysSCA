/**
 * Validate the invoice/bill no. in Inward Facultative Premium Collections
 * 
 * @author Jerome Orio 09.03.2010
 * @version 1.0
 * @param b140PremSeqNoInw
 * @return
 */
function validateInvoiceInwFacul(b140PremSeqNoInw) {
	var vMsgAlert = "";
	var a180RiCd;
	if ($("transactionTypeInw").value == "2"
			|| $("transactionTypeInw").value == "4") {
		a180RiCd = $("a180RiCdInw").value;
	} else {
		a180RiCd = $("a180RiCd2Inw").value;
	}
	new Ajax.Request(contextPath
			+ '/GIACInwFaculPremCollnsController?action=validateInvoice', {
		parameters : {
			a180RiCd : a180RiCd,
			b140IssCd : $("b140IssCdInw").value,
			transactionType : $("transactionTypeInw").value,
			b140PremSeqNoInw : b140PremSeqNoInw
		},
		asynchronous : false,
		evalScripts : true,
		onCreate : function() {
			showNotice("Validating Invoice, please wait...");
		},
		onComplete : function(response) {
			vMsgAlert = response.responseText;
		}
	});
	return vMsgAlert;
}