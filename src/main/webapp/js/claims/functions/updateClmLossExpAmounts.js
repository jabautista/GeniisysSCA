function updateClmLossExpAmounts(){
	try{
		var newObj = setGiclClmLossExpObject();
		var totalLossAmt = $("totalLossAmt").value;
		var y = giclClmLossExpenseTableGrid.getCurrentPosition()[1];
		newObj.paidAmount = unformatCurrencyValue(totalLossAmt);
		newObj.netAmount = unformatCurrencyValue(totalLossAmt);
		newObj.adviceAmount = unformatCurrencyValue(totalLossAmt);
		$("txtLossPaidAmt").value = totalLossAmt;
		$("txtLossNetAmt").value = totalLossAmt;
		$("txtLossAdviceAmt").value = totalLossAmt;
		newObj.recordStatus = 1;
		replaceClmLossExpObject(newObj);
		giclClmLossExpenseTableGrid.setValueAt(newObj.paidAmount, giclClmLossExpenseTableGrid.getColumnIndex('paidAmount'), y);
		giclClmLossExpenseTableGrid.setValueAt(newObj.netAmount, giclClmLossExpenseTableGrid.getColumnIndex('netAmount'), y);
		giclClmLossExpenseTableGrid.setValueAt(newObj.paidAmount, giclClmLossExpenseTableGrid.getColumnIndex('adviceAmount'), y);
	}catch(e){
		showErrorMessage("updateClmLossExpAmounts", e);
	}
}