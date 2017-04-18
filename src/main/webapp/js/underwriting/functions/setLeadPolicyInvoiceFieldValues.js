function setLeadPolicyInvoiceFieldValues(obj){
	$("lpRefInvNo").value 		  = (obj == null ? "" : unescapeHTML2(nvl(obj.refInvNo, "")));
	$("lpPremium").value 		  = (obj == null ? "" : formatCurrency(nvl(obj.premAmt, "")));
	$("lpTotalTax").value 		  = (obj == null ? "" : formatCurrency(nvl(obj.taxAmt, "")));
	$("lpOtherCharges").value 	  = (obj == null ? "" : formatCurrency(nvl(obj.otherCharges, "")));
	$("lpAmountDue").value 		  = (obj == null ? "" : formatCurrency(nvl(obj.amountDue, "")));
	$("lpCurrency").value 		  = (obj == null ? "" : unescapeHTML2(nvl(obj.currencyDesc, "")));
	$("lpFullRefInvNo").value 	  = (obj == null ? "" : unescapeHTML2(obj.gipiOrigInv == null ? "" : nvl(obj.gipiOrigInv.refInvNo, "")));
	$("lpFullPremium").value 	  = (obj == null ? "" : formatCurrency(obj.gipiOrigInv == null ? "" : nvl(obj.gipiOrigInv.premAmt, "")));
	$("lpFullTotalTax").value 	  = (obj == null ? "" : formatCurrency(obj.gipiOrigInv == null ? "" : nvl(obj.gipiOrigInv.taxAmt, "")));
	$("lpFullOtherCharges").value = (obj == null ? "" : formatCurrency(obj.gipiOrigInv == null ? "" : nvl(obj.gipiOrigInv.otherCharges, "")));
	$("lpFullAmountDue").value 	  = (obj == null ? "" : formatCurrency(obj.gipiOrigInv == null ? "" : nvl(obj.gipiOrigInv.amountDue, "")));
	$("lpFullCurrency").value 	  = (obj == null ? "" : unescapeHTML2(obj.gipiOrigInv == null ? "" : nvl(obj.gipiOrigInv.currencyDesc, "")));
}