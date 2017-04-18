function clearLoaRelatedTableGrids(){
	loaTableGrid.releaseKeys();
	$("txtLoaRemarks").value = "";
	$("totalDtlLoaAmt").value = formatCurrency(0);
	currLoaClmLossId = null;
	objCurrLoa = null;
	
	if($("dtlLoaTableGrid") != null){
		clearTableGridDetails(dtlLoaTableGrid);
	}
}