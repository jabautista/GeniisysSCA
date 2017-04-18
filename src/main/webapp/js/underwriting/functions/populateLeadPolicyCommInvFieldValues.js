function populateLeadPolicyCommInvFieldValues(obj){
	$("invCommCompSharePct").value 	= (obj == null ? "" : unescapeHTML2(nvl(obj.sharePercentage, "")));
	$("invCommCompPrem").value 		= (obj == null ? "" : formatCurrency(nvl(obj.premiumAmt, "")));
	$("invCommCompTotalComm").value = (obj == null ? "" : formatCurrency(nvl(obj.commissionAmt, "")));
	$("invCommCompWholdTax").value 	= (obj == null ? "" : formatCurrency(nvl(obj.wholdingTax, "")));
	$("invCommCompNetComm").value 	= (obj == null ? "" : formatCurrency(nvl(obj.netComm, "")));
	$("invCommSharePct").value 		= (obj == null ? "" : unescapeHTML2(nvl(obj.shareSharePercentage, "")));
	$("invCommPrem").value 			= (obj == null ? "" : formatCurrency(nvl(obj.sharePremiumAmt, "")));
	$("invCommTotalComm").value	 	= (obj == null ? "" : formatCurrency(nvl(obj.shareCommissionAmt, "")));
	$("invCommWholdTax").value 		= (obj == null ? "" : formatCurrency(nvl(obj.shareWholdingTax, "")));
	$("invCommNetComm").value 		= (obj == null ? "" : formatCurrency(nvl(obj.shareNetComm, "")));
}