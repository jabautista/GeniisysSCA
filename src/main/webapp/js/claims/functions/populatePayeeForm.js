function populatePayeeForm(payee){
	try{
		$("selPayeeType").value = payee == null ? $("hidDefaultPayeeType").value : unescapeHTML2(payee.payeeType);
		$("payeeClass").value   = payee == null ? "" : unescapeHTML2(payee.className);
		$("payeeClass").setAttribute("payeeClassCd", payee == null ? "" : payee.payeeClassCd);
		$("payee").value = payee == null ? "" : unescapeHTML2(payee.dspPayeeName);
		$("payee").setAttribute("payeeNo", payee == null ? "" : nvl(payee.payeeCd, ""));
		$("hidClmClmntNo").value = payee == null ? "" : payee.clmClmntNo;
		$("hidExistClmLossExp").value = payee == null ? "" : nvl(payee.existClmLossExp, "N");
		
		if(payee == null){
			enableButton($("btnAddPayee"));
			disableButton($("btnDeletePayee"));
			disableButton($("btnDeductibles"));
			$("btnPayeeClass").show();
			$("btnPayee").show();
			$("selPayeeType").enable();
		}else{
			disableButton($("btnAddPayee"));
			(payee.recordStatus == "0" ? enableButton($("btnDeletePayee")): disableButton($("btnDeletePayee")));
			enableButton($("btnDeductibles"));
			$("btnPayeeClass").hide();
			$("btnPayee").hide();
			$("selPayeeType").disable();
			//showMessageBox("You cannot update saved history details.", "I");
		}
	}catch(e){
		showErrorMessage("populatePayeeForm", e);
	}
}