function makeAllQuotationFormsHidden() {
	if (isMakeQuotationInformationFormsHidden == 1) {
		$$("input, textarea").each(function(i) {
			i.setAttribute("readonly", "readonly");
			i.setAttribute("disabled", "disabled");
		});
		$$("select, img").each(function(s) {
			s.setAttribute("disabled", "disabled");
		});
	} 
	isMakeQuotationInformationFormsHidden = 0;
	/* * $$("input[type='button'], input[type='submit'], button").each(function
	 * (button) { button.remove(); });
	 */
}