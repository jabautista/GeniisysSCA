function checkSignatoryCTCNo(ctcNo, id, fromSignatoryTable){
	var principalRows = principalSignatoryTableGrid.rows;
	var principalNewRowsAdded = principalSignatoryTableGrid.newRowsAdded;

	if(fromSignatoryTable =='Y'){
		for ( var i = 0; i < principalRows.length; i++) {
			if(principalRows[i][principalSignatoryTableGrid.getColumnIndex('resCert')] == ctcNo && principalRows[i][principalSignatoryTableGrid.getColumnIndex('divCtrId')] != id){
				showMessageBox("CTC No. already exist.", imgMessage.INFO);
				return true;
			}
		}

		for ( var w = 0; w < principalNewRowsAdded.length; w++) {
			if(principalNewRowsAdded[w][principalSignatoryTableGrid.getColumnIndex('resCert')] == ctcNo && principalNewRowsAdded[w][principalSignatoryTableGrid.getColumnIndex('divCtrId')] != id){
				showMessageBox("CTC No. already exist.", imgMessage.INFO);
				return true;
			}
		}
	}else{
		for ( var i = 0; i < principalRows.length; i++) {
			if(principalRows[i][principalSignatoryTableGrid.getColumnIndex('resCert')] == ctcNo){
				showMessageBox("CTC No. already exist.", imgMessage.INFO);
				return true;
			}
		}
		for ( var w = 0; w < principalNewRowsAdded.length; w++) {
			if(principalNewRowsAdded[w][principalSignatoryTableGrid.getColumnIndex('resCert')] == ctcNo){
				showMessageBox("CTC No. already exist.", imgMessage.INFO);
				return true;
			}
		}
	}
}