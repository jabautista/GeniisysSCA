function changeBankDetails() {
	var val = $("dcbBankName").options[$("dcbBankName").selectedIndex]
			.getAttribute("bankCd") == null ? 0
			: $("dcbBankName").options[$("dcbBankName").selectedIndex]
					.getAttribute("bankCd");
	var bankDetails = document.getElementsByName('dcbBankAccountNo');
	for ( var i = 0; i < bankDetails.length; i++) {
		if (bankDetails[i].id == 'dcbBankAccountNo' + val) {
			bankDetails[i].show();
		} else {
			bankDetails[i].hide();
		}
	}
}