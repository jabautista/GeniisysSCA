// robert 9.24.2012
function computeGdpdSumTotal() {
	var totalLocalCurrAmt = 0;
	var totalForeignCurrAmt = 0;
	for ( var i = 0; i < gdbdListTableGrid.geniisysRows.length; i++) {
		totalLocalCurrAmt = totalLocalCurrAmt
				+ parseFloat(gdbdListTableGrid.geniisysRows[i].amount);
		totalForeignCurrAmt = totalForeignCurrAmt
				+ parseFloat(gdbdListTableGrid.geniisysRows[i].foreignCurrAmt);
	}

	$("gdpdSumDspFcSumAmt").value = formatCurrency(parseFloat(nvl(
			totalForeignCurrAmt, "0")));
	$("controlDspGdbdSumAmt").value = formatCurrency(parseFloat(nvl(
			totalLocalCurrAmt, "0")));
}