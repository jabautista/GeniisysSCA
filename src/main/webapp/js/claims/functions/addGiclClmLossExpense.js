function addGiclClmLossExpense(){
	var newObj = setGiclClmLossExpObject();

	if($("btnAddClmLossExp").value == "Update"){
		newObj.recordStatus = 1;
		replaceClmLossExpObject(newObj);
		giclClmLossExpenseTableGrid.updateVisibleRowOnly(newObj, giclClmLossExpenseTableGrid.getCurrentPosition()[1]);			
	}else{
		giclClmLossExpenseTableGrid.addBottomRow(newObj);
		clmLossExpInsertSw = "Y";
		$("hidNextClmLossId").value = parseInt($("hidNextClmLossId").value) + 1;
	}
	($$("div#clmLossExpenseDiv [changed=changed]")).invoke("removeAttribute", "changed");
	updateTGPager(giclClmLossExpenseTableGrid);
	clearAllRelatedClmLossExpRecords();
	$("txtHistSeqNo").value = lpad(getNextHistSeqNo(), 3, "0");
	changeTag = 1;
}