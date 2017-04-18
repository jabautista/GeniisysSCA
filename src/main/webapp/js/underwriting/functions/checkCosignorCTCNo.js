function checkCosignorCTCNo(ctcNo,id, fromCosignorTable){
	var cosignorRows = cosignorResTableGrid.rows;
	var cosignorNewRowsAdded = cosignorResTableGrid.newRowsAdded;
	if (fromCosignorTable == 'Y') {
		for ( var i = 0; i < cosignorRows.length; i++) {
			if(cosignorRows[i][cosignorResTableGrid.getColumnIndex('cosignResNo')] == ctcNo && cosignorRows[i][cosignorResTableGrid.getColumnIndex('divCtrId')] != id){
				showMessageBox("CTC No. already exist.", imgMessage.INFO);
				return true;
			}	
		} 
		for ( var w = 0; w < cosignorNewRowsAdded.length; w++) {
			if(cosignorNewRowsAdded[w][cosignorResTableGrid.getColumnIndex('cosignResNo')] == ctcNo && cosignorRows[w][cosignorResTableGrid.getColumnIndex('divCtrId')] != id){
				showMessageBox("CTC No. already exist.", imgMessage.INFO);
				return true;
			}
		}
	} else {
		for ( var i = 0; i < cosignorRows.length; i++) {
			if(cosignorRows[i][cosignorResTableGrid.getColumnIndex('cosignResNo')] == ctcNo ){
				showMessageBox("CTC No. already exist.", imgMessage.INFO);
				return true;
			}	
		} 
		for ( var w = 0; w < cosignorNewRowsAdded.length; w++) {
			if(cosignorNewRowsAdded[w][cosignorResTableGrid.getColumnIndex('cosignResNo')] == ctcNo ){
				showMessageBox("CTC No. already exist.", imgMessage.INFO);
				return true;
			}
		}
	}
}