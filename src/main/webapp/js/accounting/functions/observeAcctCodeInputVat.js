/**
 * Create observe event for Account Code in module GIACS039
 * 
 * @author Jerome Orio 09.23.2010
 * @version 1.0
 * @param
 * @return
 */
function observeAcctCodeInputVat() {
	var arr = [ "txtGlAcctCategoryInputVat", "txtGlControlAcctInputVat",
			"txtGlSubAcct1InputVat", "txtGlSubAcct2InputVat",
			"txtGlSubAcct3InputVat", "txtGlSubAcct4InputVat",
			"txtGlSubAcct5InputVat", "txtGlSubAcct6InputVat",
			"txtGlSubAcct7InputVat" ];
	var preValue = "";
	for ( var a = 0; a < arr.length; a++) {
		$(arr[a]).observe("focus", function(rec) {
			preValue = this.value;
		});
		$(arr[a]).observe("blur", function(rec) {
			if (this.value == "") {
				$("hidGlAcctIdInputVat").clear();
				$("hidGsltSlTypeCdInputVat").clear();
				$("txtDspAccountName").clear();
			} else {
				if (preValue != this.value) {
					$("hidSlCdInputVat").clear();
					$("txtSlNameInputVat").clear();
					validateAcctCodeInputVat();
				}
			}
		});
	}
}