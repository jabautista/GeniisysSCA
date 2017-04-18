/* to check if Print button will be enabled in warranties and clauses page */
function checkIfWillPrint() {
	if ($$("img.printCheck").size() > 0) {
		enableButton("btnPrintQuotationWC");
	} else {
		disableButton("btnPrintQuotationWC");
	}
}