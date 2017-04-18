/**
 * Prepare content of Direct Trans Input Vat List in module GIACS039
 * 
 * @author Jerome Orio 09.21.2010
 * @version 1.0
 * @param JSONObject
 *            to be used in listing
 * @return Content of record list
 */
function prepareDirectTransInputVat(obj) {
	try {
		var inputVat = "<label style='text-align: left; width: 10%; margin-right: 3px;'>"
				+ obj.transactionType
				+ " - "
				+ (obj.transactionTypeDesc == ""
						|| obj.transactionTypeDesc == null ? "---"
						: changeSingleAndDoubleQuotes(obj.transactionTypeDesc)
								.truncate(13, "..."))
				+ "</label>"
				+ "<label style='text-align: left; width: 10%; margin-right: 3px;'>"
				+ (obj.payeeClassDesc == "" || obj.payeeClassDesc == null ? "---"
						: changeSingleAndDoubleQuotes(obj.payeeClassDesc)
								.truncate(13, "..."))
				+ "</label>"
				+ "<label style='text-align: left; width: 10%; margin-right: 3px;'>"
				+ (obj.dspPayeeName == "" || obj.dspPayeeName == null ? "---"
						: changeSingleAndDoubleQuotes(obj.dspPayeeName)
								.truncate(11, "..."))
				+ "</label>"
				+ "<label style='text-align: left; width: 12%; margin-right: 3px;'>"
				+ (obj.referenceNo == "" || obj.referenceNo == null ? "---"
						: changeSingleAndDoubleQuotes(obj.referenceNo)
								.truncate(16, "..."))
				+ "</label>"
				+ "<label style='text-align: right; width: 6%; margin-right: 15px;'>"
				+ (obj.itemNo == "" || obj.itemNo == null ? "---" : obj.itemNo
						.toString().truncate(9, "..."))
				+ "</label>"
				+ "<label style='text-align: left; width: 10%; margin-right: 2px;'>"
				+ (obj.vatSlName == "" || obj.vatSlName == null ? "---"
						: changeSingleAndDoubleQuotes(obj.vatSlName).truncate(
								12, "..."))
				+ "</label>"
				+ "<label style='text-align: right; width: 14%; margin-right: 3px;' class='money'>"
				+ formatCurrency(
						(obj.baseAmt == null ? 0 : nvl(parseFloat(obj.baseAmt
								.replace(/,/g, "")), 0))
								+ (obj.inputVatAmt == null ? 0 : nvl(
										parseFloat(obj.inputVatAmt.replace(
												/,/g, "")), 0))).truncate(18,
						"...")
				+ "</label>"
				+ "<label style='text-align: right; width: 12%; margin-right: 3px;' class='money'>"
				+ (obj.baseAmt == "" || obj.baseAmt == null ? "---"
						: formatCurrency(obj.baseAmt.toString()).truncate(18,
								"..."))
				+ "</label>"
				+ "<label style='text-align: right; width: 12%;' class='money'>"
				+ (obj.inputVatAmt == "" || obj.inputVatAmt == null ? "---"
						: formatCurrency(obj.inputVatAmt.toString()).truncate(
								18, "...")) + "</label>";
		return inputVat;
	} catch (e) {
		showErrorMessage("prepareDirectTransInputVat", e);
		// showMessageBox("Error preparing Input Vat List, "+e.message,
		// imgMessage.ERROR);
	}
}