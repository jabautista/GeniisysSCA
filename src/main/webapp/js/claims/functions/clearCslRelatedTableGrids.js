function clearCslRelatedTableGrids(){
	cslTableGrid.releaseKeys();
	$("txtCslRemarks").value = "";
	$("totalDtlCslAmt").value = formatCurrency(0);
	objCurrCsl = null;
	currCslClmLossId = null;
	
	if($("dtlCslTableGrid") != null){
		clearTableGridDetails(dtlCslTableGrid);
	}
}