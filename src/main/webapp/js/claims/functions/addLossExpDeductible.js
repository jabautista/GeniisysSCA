function addLossExpDeductible(){
	var newObj = setLossExpDeductibleObject();
	if($("btnAddLossExpDeductible").value == "Update"){
		updateLossExpDeductible(newObj);
	}else{
		if(checkIfLossExpDeductibleExists(newObj)){
			showMessageBox("Record already exists.", "I");
			return false;
		}else{
			lossExpDeductiblesTableGrid.addBottomRow(newObj);
			updateTGPager(lossExpDeductiblesTableGrid);
			populateLossExpDeductibleForm(null);
			computeTotalDeductibleAmt();
		}
	}
}