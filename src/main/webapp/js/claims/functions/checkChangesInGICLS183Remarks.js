/* 
 * shan
 * 01.11.2013
 */
function checkChangesInGICLS183Remarks(){
	var remarksChanged = false;
	for (var i =0; i < functionOverrideRecordsTableGrid.rows.length; i++){
		if (functionOverrideRecordsTableGrid.getValueAt(functionOverrideRecordsTableGrid.getColumnIndex('origRemarks'), i) != 
				functionOverrideRecordsTableGrid.getValueAt(functionOverrideRecordsTableGrid.getColumnIndex('remarks'), i)){
			remarksChanged = true;
			break;
		}
	}
	
	return remarksChanged;
}