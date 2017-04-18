function clearPackParCreationFields() {
	try {
		$("assuredNo").clear();
		$("address1").clear();
		$("address2").clear();
		$("address3").clear();
		$("vlineCd").clear();
		$("vissCd").clear();
		$("packIssCd").clear();
		//$("sublineCd").value = "";
		$("packLineCdSel").clear();
		//$("sublinecd").value = "";
		$("year").value = $("defaultYear").value;
		$("parSeqNo").clear();
		$("quoteSeqNo").value = "00";
		$("assuredName").clear();
		$("remarks").clear();
		$("packQuoteId").clear();
	} catch (e) {
		showErrorMessage("clearPackParCreationFields", e);
	}
}