/**
 * Set local and foreign currency amount total (POPULATE_GICD_SUM)
 * 
 * @author eman
 */
function computeGicdSumTotal() {
	var totalLocalCurrAmt = 0;
	var totalForeignCurrAmt = 0;
	for ( var i = 0; i < gicdSumListTableGrid.geniisysRows.length; i++) {
		totalLocalCurrAmt = totalLocalCurrAmt
				+ parseFloat(gicdSumListTableGrid.geniisysRows[i].dspAmount);
		totalForeignCurrAmt = totalForeignCurrAmt
				+ parseFloat(gicdSumListTableGrid.geniisysRows[i].dspFcAmt);
	}

	$("gicdSumDspFcSumAmt").value = formatCurrency(parseFloat(nvl(
			totalForeignCurrAmt, "0")));
	$("controlDspGicdSumAmt").value = formatCurrency(parseFloat(nvl(
			totalLocalCurrAmt, "0")));
}