/**
 * Prepare content of Direct Trans Loss Recoveries List in module GIACS010
 * 
 * @author Jerome Orio 10.06.2010
 * @version 1.0
 * @param JSONObject
 *            to be used in listing
 * @return Content of record list
 */
function prepareDirectTransLossRecoveries(obj) {
	try {
		var lossRecoveries = "<label style='width: 4%; text-align: right;'>";

		if (obj.acctEntTag == 'Y') { // by bonok :: test case :: 03.15.2012
			lossRecoveries += '<img name="checkedImg" class="printCheck" src="'
					+ checkImgSrc
					+ '" style="width: 10px; height: 10px; text-align: right; display: block; margin-left: 5px;" />'; // added
																														// A
																														// column
																														// ::
																														// by
																														// bonok
																														// ::
																														// test
																														// case
																														// ::
																														// 03.15.2012
		} else {
			lossRecoveries += '<span style="float: left; width: 10px; height: 10px; margin-left: 3px;">-</span>';
		}

		lossRecoveries += '</label>'
				+ "<label style='text-align: left; width: 19%; margin-right: 3px;'>"
				+ obj.transactionType
				+ " - "
				+ (obj.transactionTypeDesc == ""
						|| obj.transactionTypeDesc == null ? "---"
						: changeSingleAndDoubleQuotes(obj.transactionTypeDesc)
								.truncate(18, "..."))
				+ "</label>"
				+ "<label style='text-align: left; width: 19%; margin-right: 3px;'>"
				+ (obj.lineCd == "" || obj.lineCd == null ? "---" : obj.lineCd)
				+ "-"
				+ (obj.issCd == "" || obj.issCd == null ? "---" : obj.issCd)
				+ "-"
				+ (obj.recYear == "" || obj.recYear == null ? "---"
						: obj.recYear)
				+ "-"
				+ (obj.recSeqNo == "" || obj.recSeqNo == null ? "---"
						: formatNumberDigits(obj.recSeqNo, 3))
				+ "</label>"
				+ "<label style='text-align: left; width: 20%; margin-right: 3px;'>"
				+ (obj.payorClassDesc == "" || obj.payorClassDesc == null ? "---"
						: changeSingleAndDoubleQuotes(obj.payorClassDesc)
								.truncate(22, "..."))
				+ "</label>"
				+ "<label style='text-align: left; width: 20%; margin-right: 3px;'>"
				+ (obj.payorName == "" || obj.payorName == null ? "---"
						: changeSingleAndDoubleQuotes(obj.payorName).truncate(
								18, "..."))
				+ "</label>"
				+ "<label style='text-align: right; width: 16%;' class='money'>"
				+ (obj.collectionAmt == "" || obj.collectionAmt == null ? "---"
						: formatCurrency(obj.collectionAmt.toString())
								.truncate(22, "...")) + "</label>";

		return lossRecoveries;
	} catch (e) {
		showErrorMessage("prepareDirectTransLossRecoveries", e);
		// showMessageBox("Error preparing Loss Recoveries List, "+e.message,
		// imgMessage.ERROR);
	}
}