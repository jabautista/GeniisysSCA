function setPayeeDetailObject(){
	var newPayee = new Object();
	
	newPayee.claimId 		= objCLMGlobal.claimId;
	newPayee.itemNo 		= objCurrGICLItemPeril.itemNo;
	newPayee.perilCd 		= objCurrGICLItemPeril.perilCd;
	newPayee.groupedItemNo 	= objCurrGICLItemPeril.groupedItemNo;
	newPayee.payeeType 		= escapeHTML2($("selPayeeType").value);
	newPayee.payeeTypeDesc 	= escapeHTML2($("selPayeeType").options[$("selPayeeType").selectedIndex].text);
	newPayee.payeeClassCd 	= escapeHTML2($("payeeClass").getAttribute("payeeClassCd"));
	newPayee.className 		= escapeHTML2($("payeeClass").value);
	newPayee.payeeCd 		= escapeHTML2($("payee").getAttribute("payeeNo"));
	newPayee.dspPayeeName 	= escapeHTML2($("payee").value);
	newPayee.clmClmntNo 	= $("hidClmClmntNo").value;
	newPayee.existClmLossExp = $("hidExistClmLossExp").value;
	
	return newPayee;
}