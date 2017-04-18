function populateClmLossExpForm(clmLossExp){
	try{
		$("txtHistSeqNo").value = clmLossExp == null ? "" : clmLossExp.historySequenceNumber == null ? "" : lpad(clmLossExp.historySequenceNumber, 3, "0");
		$("txtLossPaidAmt").value = clmLossExp == null ? "" :formatCurrency(clmLossExp.paidAmount);
		$("txtHistStatus").value = clmLossExp == null ? "" : unescapeHTML2(clmLossExp.clmLossExpStatDesc);
		$("txtHistStatus").setAttribute("histStatus", clmLossExp == null ? "" :clmLossExp.itemStatusCd);
		$("txtLossNetAmt").value = clmLossExp == null ? "" : formatCurrency(clmLossExp.netAmount);
		$("txtRemarks").value = clmLossExp == null ? "" : unescapeHTML2(clmLossExp.remarks);
		$("txtLossAdviceAmt").value = clmLossExp == null ? "" : formatCurrency(clmLossExp.adviceAmount);
		$("hidClmLossId").value = clmLossExp == null ? $("hidNextClmLossId").value : clmLossExp.claimLossId;
		$("btnAddClmLossExp").value = clmLossExp == null ? "Add" : "Update";
		(clmLossExp == null ? disableButton($("btnDeleteClmLossExp")) : enableButton($("btnDeleteClmLossExp")));
		
		if(clmLossExp == null){
			$("chkExGratia").checked = false;
			$("chkFinalTag").checked = false;
		}else{
			$("chkExGratia").checked = nvl(clmLossExp.exGratiaSw, "N") == "Y" ? true :false;
			$("chkFinalTag").checked = nvl(clmLossExp.finalTag, "N") == "Y" ? true :false;
		}
		
		checkClmLossExpForUpdate(clmLossExp);
		setLossExpHistButtons(clmLossExp);
	}catch(e){
		showErrorMessage("populateClmLossExpForm", e);
	}
}