function checkChangeOfRecordInTG(tableGrid, currObj){
	try{
		var ok = true;
		 
		if (changeTag == 1 || checkLossExpChildRecords()){
			ok = false;
			var currIndex = nvl(currObj, null) == null ? null : String(currObj.index);
			
			showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
				if (nvl(tableGrid,null) instanceof MyTableGrid) tableGrid.unselectRows();
				if (nvl(currIndex,null) != null){
					if (nvl(tableGrid,null) instanceof MyTableGrid){
						tableGrid.selectRow(currIndex);
						tableGrid.keys._xCurrentPos = 1; 
						tableGrid.keys._yCurrentPos = currIndex;
					}
				}
			});
		}
		
		return ok;
	}catch(e){
		showErrorMessage("checkChangeOfRecordInTG", e);	
	}
}