/**
 * Disable input fields in Cancel OR
 * 
 * @author Steven
 * @param reqDivArray -
 *            put in array the div id,if you want to remove the "required"
 *            classname and disable it ,if the classname of a text or textarea
 *            is "txtReadOnly" it makes it readOnly ,if the classname of an
 *            image is "cancelORSearch" it disables the Search icon ,if the
 *            classname of a button is "cancelORBtn" it disables the button
 * @return
 */
function disableCancelORFields(reqDivArray) {
	try {
		if (reqDivArray != null) {
			for ( var i = 0; i < reqDivArray.length; i++) {
				$$(
						"div#" + reqDivArray[i]
								+ " input[type='text'].required, div#"
								+ reqDivArray[i] + " textarea.required, div#"
								+ reqDivArray[i] + " select.required").each(
						function(a) {
							$(a).removeClassName("required");
							$(a).disable();
						});
//				$$(
//						"div#" + reqDivArray[i]
//								+ " input[type='text'].txtReadOnly, div#"
//								+ reqDivArray[i] + " textarea.txtReadOnly")
//						.each(function(b) {
//							$(b).readOnly = "true";
//						});
				$$(
						"div#" + reqDivArray[i]
								+ " input[type='text'], div#"
								+ reqDivArray[i] + " textarea")
						.each(function(b) { //change by steven 10.30.2013
							$(b).readOnly = "true";
						});
				$$("div#" + reqDivArray[i] + " img.cancelORSearch").each(
						function(c) {
							disableSearch(c);
						});
				$$(
						"div#" + reqDivArray[i]
								+ " input[type='button'].cancelORBtn").each(
						function(d) {
							disableButton(d);
						});
			}
		}
	} catch (e) {
		showErrorMessage("disableModuleFields", e);
	}
}