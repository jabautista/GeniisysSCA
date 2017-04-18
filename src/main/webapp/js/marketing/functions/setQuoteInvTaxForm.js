/**
* Populate quote invoice tax form with values.
* @param invTaxObj - JSON Object that contains the quote invoice tax information. Set invTaxObj
* 				      to null to reset quote invoice tax form. 
*/

function setQuoteInvTaxForm(invTaxObj){
	$("txtTaxCharges").value = invTaxObj == null ? "" : unescapeHTML2(invTaxObj.taxDescription);
	$("txtTaxValue").value = invTaxObj == null ? "" : formatCurrency(invTaxObj.taxAmt);
	
	$("btnAddInvTax").value = invTaxObj == null ? "Add" : "Update";
	(invTaxObj == null ? disableButton($("btnDeleteInvTax")) : enableButton($("btnDeleteInvTax")));
	
	if(invTaxObj != null){
		$("hrefTaxCharges").hide();
		$("txtTaxCharges").writeAttribute("taxCd", invTaxObj.taxCd);
		$("txtTaxCharges").writeAttribute("taxId", invTaxObj.taxId);
		$("txtTaxCharges").writeAttribute("lineCd", invTaxObj.lineCd);
		$("txtTaxCharges").writeAttribute("issCd", invTaxObj.issCd);
		$("txtTaxCharges").writeAttribute("rate", invTaxObj.rate);
		$("txtTaxCharges").writeAttribute("primarySw", invTaxObj.primarySw);
	}else{
		$("hrefTaxCharges").show();
		$("txtTaxCharges").writeAttribute("taxCd", "");
		$("txtTaxCharges").writeAttribute("taxId", "");
		$("txtTaxCharges").writeAttribute("lineCd", "");
		$("txtTaxCharges").writeAttribute("issCd", "");
		$("txtTaxCharges").writeAttribute("rate", "");
		$("txtTaxCharges").writeAttribute("primarySw", "");
	}
}