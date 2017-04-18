function toggleGIACS230Fields(enable) {
	if (nvl(enable, false) == true) {
		$$("div#glAcctTranHeaderDiv input[type='text']").each(function(txt) {
			txt.readOnly = false;
		});
		enableSearch("searchGLAcctLOV");
		enableSearch("searchCompanyLOV");
		enableSearch("searchBranchLOV");
		enableDate("imgFromDate");
		enableDate("imgToDate");
		$("tranDateRB").disabled = false;
		$("postedDateRB").disabled = false;
		$("chkTranOpen").disabled = false;
	} else {
		$$("div#glAcctTranHeaderDiv input[type='text']").each(function(txt) {
			txt.readOnly = true;
		});
		disableSearch("searchGLAcctLOV");
		disableSearch("searchCompanyLOV");
		disableSearch("searchBranchLOV");
		disableDate("imgFromDate");
		disableDate("imgToDate");
		$("tranDateRB").disabled = true;
		$("postedDateRB").disabled = true;
		$("chkTranOpen").disabled = true;
	}
}