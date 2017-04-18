function computeTotalFields(repairGrid){
	var dspTotalT =0;
	var dspTotalP = 0;
	for ( var i = 0; i < repairGrid.rows.length; i++) {
		dspTotalT = dspTotalT + parseFloat((nvl(repairGrid.getRow(i).tinsmithAmount,"0")));
		dspTotalP = dspTotalP + parseFloat((nvl(repairGrid.getRow(i).paintingsAmount,"0")));
	}
	$("dspTotalT").value = formatCurrency(dspTotalT);
	$("dspTotalP").value = formatCurrency(dspTotalP);
}