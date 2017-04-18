/**
 * @author rey
 * @date 08-08-2011
 * @param obj
 */
function populateInvoiceCommission(obj){
	$("intmCdName").value       = (obj == null ? "" : unescapeHTML2(nvl(obj.intmCdName, "")));
	$("refIntmCd").value        = (obj == null ? "" : (nvl(obj.refIntmCd, "")));
	$("parentIntmNo").value     = (obj == null ? "" : (nvl(obj.parentIntmNo, "")));
	$("sharePercentage").value  = (obj == null ? "" : formatToNineDecimal(nvl(obj.sharePercentage, "")));
	$("premiumAmt").value       = (obj == null ? "" : formatCurrency(nvl(obj.sharePrem, "")));
	$("totalCommission").value  = (obj == null ? "" : formatCurrency(nvl(obj.totalCommission, "")));
	$("totalTaxWholding").value = (obj == null ? "" : formatCurrency(nvl(obj.totalTaxWholding, "")));
	$("netComAmt").value        = (obj == null ? "" : formatCurrency(nvl(obj.netComAmt, "")));
}