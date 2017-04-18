/**
 * @author rey
 * @date 08-02-2011
 * @param obj
 */
function populateBillPremiumMain(obj){
	$("billNo").value           = (obj == null ? "" : unescapeHTML2(nvl(obj.billNo, "")));
	$("invRefNo").value         = (obj == null ? "" : unescapeHTML2(nvl(obj.refInvNo, "")));
	$("paytTerms").value        = (obj == null ? "" : unescapeHTML2(nvl(obj.paytTerms, "")));
	$("property").value         = (obj == null ? "" : unescapeHTML2(nvl(obj.property, "")));
	//$("dueDate").value          = (obj == null ? "" : dateFormat((nvl(obj.dueDate, "")),"mm-dd-yyyy"));
	$("dueDate").value			= (obj == null ? "" : unescapeHTML2(nvl(obj.strDueDate, "")));
	//$("acctEntDt").value        = (obj == null ? "" : obj.strAcctEntDt != undefined ? obj.strAcctEntDt : (obj.acctEntDate != null || obj.acctEntDate != "") ? dateFormat(obj.acctEntDate, "mm-dd-yyyy") : ""); //removed by robert SR 21759 03.08.2016
	$("acctEntDt").value        = (obj == null ? "" : obj.acctEntDate != null ? dateFormat(obj.acctEntDate, "mm-dd-yyyy") : ""); //added by robert SR 21759 03.08.2016
	$("otherCharges").value     = (obj == null ? "" : unescapeHTML2(nvl(obj.otherCharges, "")));
	$("currencyDesc").value     = (obj == null ? "" : unescapeHTML2(nvl(obj.currencyDesc, "")));
	$("multiBookingDt").value   = (obj == null ? "" : unescapeHTML2(nvl(obj.multiBookingDt, "")));
	$("remarks").value          = (obj == null ? "" : unescapeHTML2(nvl(obj.remarks, "")));
	$("amountDue").value        = (obj == null ? "" : formatCurrency(nvl(obj.amountDue, "")));
	//$("annPremAmt").value       = (obj == null ? "" : formatCurrency(nvl(obj.annPremAmt, ""))); -- marco - 09.06.2012
	$("annPremAmt").value       = (obj == null ? "" : formatCurrency(nvl(obj.sumPremAmt, ""))); //formatCurrency(nvl(obj.premAmt, ""))); replaced by: Nica 05.15.2013
	$("taxAmt").value           = (obj == null ? "" : formatCurrency(nvl(obj.taxSum, "")));
	$("policyCurrency").checked = (obj == null ? false : (nvl(obj.policyCurrency,"N") == "Y" ? true : false));
	$("riCommAmt").value           = (obj == null ? "" : formatCurrency(nvl(obj.riCommAmt, ""))); //nieko 07252016 SR 5463, KB 2990
	$("riCommVat").value           = (obj == null ? "" : formatCurrency(nvl(obj.riCommVat, ""))); //nieko 07252016 SR 5463, KB 2990
}