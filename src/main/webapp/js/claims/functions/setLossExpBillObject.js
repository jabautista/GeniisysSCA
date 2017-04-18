function setLossExpBillObject(){
	var lossExpBill = new Object();
	
	lossExpBill.claimId			= objCLMGlobal.claimId;
	lossExpBill.claimLossId 	= objCurrGICLClmLossExpense.claimLossId;
	lossExpBill.payeeClassCd	= $("txtBillPayeeClassCd").getAttribute("payeeClassCd");
	lossExpBill.dspPayeeClass	= escapeHTML2($("txtBillPayeeClassCd").value);
	lossExpBill.payeeCd			= $("txtBillPayeeCd").getAttribute("payeeCd");
	lossExpBill.dspPayee		= escapeHTML2($("txtBillPayeeCd").value);
	lossExpBill.docType			= $("selDocType").value;
	lossExpBill.docTypeDesc		= escapeHTML2($("selDocType").options[$("selDocType").selectedIndex].text);
	lossExpBill.docNumber		= escapeHTML2($("txtDocNumber").value);
	lossExpBill.amount			= unformatCurrencyValue($("txtBillAmt").value);
	lossExpBill.remarks			= escapeHTML2($("txtBillRemarks").value);
	lossExpBill.billDate		= $("txtBillDate").value;
	
	return lossExpBill; 
}