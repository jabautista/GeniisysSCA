/**
 * Prepare content of Ri Trans Loss Recov from RI (GIACS009)
 * 
 * @author Jerome Orio 10.27.2010
 * @version 1.0
 * @param JSONObject
 *            to be used in listing
 * @return Content of record list
 */
function prepareRiTransLossesRecov(obj) {
	try {
		var lossesRecov = '<label style="text-align: left; width: 18%; margin-right: 4px;">'
				+ obj.transactionType
				+ " - "
				+ (obj.transactionTypeDesc == ""
						|| obj.transactionTypeDesc == null ? "---"
						: changeSingleAndDoubleQuotes(obj.transactionTypeDesc)
								.truncate(12, "..."))
				+ '</label>'
				+ '<label style="text-align: left; width: 15%; margin-right: 3px;">'
				+ (obj.shareTypeDesc == "" || obj.shareTypeDesc == null ? "---"
						: changeSingleAndDoubleQuotes(obj.shareTypeDesc)
								.truncate(15, "..."))
				+ '</label>'
				+ '<label style="text-align: left; width: 18%; margin-right: 3px;">'
				+ (obj.riName == "" || obj.riName == null ? "---"
						: changeSingleAndDoubleQuotes(obj.riName).truncate(20,
								"..."))
				+ '</label>'
				+ '<label style="text-align: left; width: 18%; margin-right: 3px;">'
				+ (obj.e150LineCd == "" || obj.e150LineCd == null ? "---"
						: obj.e150LineCd)
				+ "-"
				+ (obj.e150LaYy == "" || obj.e150LaYy == null ? "---"
						: formatNumberDigits(obj.e150LaYy, 2))
				+ "-"
				+ (obj.e150FlaSeqNo == "" || obj.e150FlaSeqNo == null ? "---"
						: formatNumberDigits(obj.e150FlaSeqNo, 5))
				+ '</label>'
				+ '<label style="text-align: left; width: 9%; margin-right: 3px;">'
				+ (obj.payeeType == "" || obj.payeeType == null ? "---"
						: changeSingleAndDoubleQuotes(obj.payeeType).truncate(
								10, "..."))
				+ '</label>'
				+ '<label style="text-align: right; width: 20%;">'
				+ (obj.collectionAmt == "" || obj.collectionAmt == null ? "---"
						: formatCurrency(obj.collectionAmt.toString())
								.truncate(22, "...")) + '</label>';
		return lossesRecov;
	} catch (e) {
		showErrorMessage("prepareRiTransLossesRecov", e);
	}
}