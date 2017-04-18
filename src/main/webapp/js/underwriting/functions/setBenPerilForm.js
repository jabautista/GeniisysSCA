function setBenPerilForm(obj) {
	try {
		$("bpPerilCd").value	= obj == null ? "" : obj.perilCd;
		$("bpTsiAmt").value		= obj == null ? "" : obj.tsiAmt;

		(obj == null ? disableButton($("btnDeleteBeneficiaryPerils")) : enableButton($("btnDeleteBeneficiaryPerils")));
		(obj == null ? $("btnAddBeneficiaryPerils").value = "Add" : $("btnAddBeneficiaryPerils").value = "Update");
	} catch(e) {
		showErrorMessage("setBenPerilForm", e);
	}
}