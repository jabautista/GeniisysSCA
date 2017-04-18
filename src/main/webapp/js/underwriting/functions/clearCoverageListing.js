function clearCoverageListing() {
	if(!$("coverageListing").empty()) {
		$$("div#coverageListing div[name='cvgRow']").each(
			function(cr) {
				cr.remove();
			}
		);
	}
	if(!$("gBeneficiaryListing").empty()) {
		$$("div#gBeneficiaryListing div[name='gBenRow']").each(
			function(gr) {
				gr.remove();
			}
		);
	}
}