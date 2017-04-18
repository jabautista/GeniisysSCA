function populateLossExpBillForm(bill){
	try{
		$("selDocType").value = bill == null ? 1 : bill.docType;
		$("txtBillDate").value = bill == null ? "" : nvl(bill.billDate, "") == "" ? "" : dateFormat(bill.billDate, "mm-dd-yyyy");
		$("txtBillPayeeClassCd").value = bill == null ? "" : unescapeHTML2(bill.dspPayeeClass);
		$("txtBillPayeeClassCd").setAttribute("payeeClassCd", bill == null ? "" : bill.payeeClassCd);
		$("txtBillPayeeCd").value = bill == null ? "" : unescapeHTML2(bill.dspPayee);
		$("txtBillPayeeCd").setAttribute("payeeCd", bill == null ? "" : bill.payeeCd);
		$("txtDocNumber").value = bill == null ? "" : unescapeHTML2(bill.docNumber);
		$("txtBillAmt").value = bill == null ? "" : formatCurrency(bill.amount);
		$("txtBillRemarks").value = bill == null ? "" : unescapeHTML2(bill.remarks);
		$("btnAddLossExpBill").value = bill == null ? "Add" : "Update";
		(bill == null ? disableButton($("btnDeleteLossExpBill")) : enableButton($("btnDeleteLossExpBill")));
		
		if(bill == null){ // add
			$("selDocType").enable(); 
			$("hrefBillPayeeClassCd").show();
			$("hrefBillPayeeCd").show();
			$("txtDocNumber").readOnly = false;
		}else{ // update - to disallow updates of primary keys
			$("selDocType").disable(); 
			$("hrefBillPayeeClassCd").hide();
			$("hrefBillPayeeCd").hide();
			$("txtDocNumber").readOnly = true;
		}
		checkLossExpBillForUpdate();
	}catch(e){
		showErrorMessage("populateLossExpBillForm", e);
	}
}