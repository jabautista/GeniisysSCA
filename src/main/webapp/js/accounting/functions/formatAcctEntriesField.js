/**
 * Hide and Shows the textfields in GIACS030 if it is called by GIACS003
 * 
 * @author Steven Ramirez
 * @date 04.09.2013
 */
function formatAcctEntriesField() {
	try {
		var journalEntriesRow = objACGlobal.hidObjGIACS003.journalEntriesRow;
		hideArray = [ "lblAmount", "grossAmtCurrency", "grossAmt", "payor",
				"lblLocAmt", "fCurrency", "fCurrencyAmt" ];
		for ( var i = 0; i < hideArray.length; i++) {
			if ($(hideArray[i]) != null) {
				$(hideArray[i]).hide();
			}
		}
		$("lblTranNo").innerHTML = "Tran ID:";
		$("lblTranNo").title = "Tran ID:";
		$("lblOrNo").innerHTML = "JV No:";
		$("lblOrNo").title = "JV No:";
		$("lblOrStatus").innerHTML = "Status:";
		$("lblOrStatus").title = "Status:";
		$("lblOrDate").innerHTML = "Tran Date:";
		$("lblOrDate").title = "Tran Date:";
		$("payorText").innerHTML = "Tran No:";
		$("payorText").setStyle({
			width : '6%'
		});
		$("payorText").next("td", 0).colSpan = "3";
		$("payorText").next("td", 0).innerHTML = "<input id='txtTranYy' class='rightAligned' type='text' style='width: 79px;' name='txtTranYr' readonly='readonly'>"
				+ "&nbsp-&nbsp"
				+ "<input id='txtTranMm' class='rightAligned' type='text' style='width: 69px;' name='txtTranMm' readonly='readonly'>"
				+ "&nbsp-&nbsp"
				+ "<input id='txtTranSeqNo' class='rightAligned' type='text' style='width: 78px;' name='txtTranSeqNo' readonly='readonly'>";
		$("payorText").next("td", 1).innerHTML = "Tran Class:";
		$("payorText").next("td", 2).colSpan = "2";
		$("payorText").next("td", 2).addClassName("leftAligned");
		$("payorText").next("td", 2).innerHTML = "<input id='txtTranClass' type='text' readonly='readonly' style='width: 40px;' name='txtTranClass'>";

		$("fundCd").value = journalEntriesRow.fundCd;
		$("branch").value = journalEntriesRow.branchCd;
		$("transactionNo").value = nvl(journalEntriesRow.tranYy, "") + " - "
				+ lpad(journalEntriesRow.tranMm, 2, 0) + " - "
				+ lpad(journalEntriesRow.tranSeqNo, 5, 0);

		$("orNo").value = nvl(journalEntriesRow.jvPrefSuff, "") + " - "
				+ lpad(journalEntriesRow.jvNo, 6, 0);
		$("orStatus").value = unescapeHTML2(nvl(journalEntriesRow.meanTranFlag,
				""));
		$("orDate").value = journalEntriesRow.strTrandate;

		$("txtTranYy").value = nvl(journalEntriesRow.tranYy, "");
		$("txtTranMm").value = lpad(journalEntriesRow.tranMm, 2, 0);
		$("txtTranSeqNo").value = lpad(journalEntriesRow.tranSeqNo, 5, 0);
		$("txtTranClass").value = nvl(journalEntriesRow.tranClass, "");
	} catch (e) {
		showErrorMessage("formatAcctEntriesField", e);
	}
}