function clearBenListing() {
	if(!$("beneficiaryListing").empty()) {
		$$("div#beneficiaryListing div[name='rowBen']").each(
			function(br) {
				br.remove();
			}
		);
	}
}