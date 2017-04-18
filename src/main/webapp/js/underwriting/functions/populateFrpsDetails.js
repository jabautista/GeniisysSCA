//belle 06282011 for FRPS Listing
function populateFrpsDetails(obj){
	$("assdName").value   = (obj == null ? "" : unescapeHTML2(nvl(obj.assdName,"")));
	$("packPolNo").value  = (obj == null ? "" : unescapeHTML2(nvl(obj.packPolNo,"")));
	$("refPolNo").value   = (obj == null ? "" : unescapeHTML2(nvl(obj.refPolNo,"")));
	$("covFrom").value	  = (obj == null ? "" : (obj.effDate == null ? "" : dateFormat(obj.effDate,"mm-dd-yyyy")));
	$("covTo").value      = (obj == null ? "" : (obj.expiryDate == null ? "" : dateFormat(obj.expiryDate,"mm-dd-yyyy")));
	$("currDesc").value   = (obj == null ? "" : unescapeHTML2(nvl(obj.currDesc,"")));
	$("distNo").value     = (obj == null ? "" : formatNumberDigits(nvl(obj.distNo,""), 8));
	$("distSeqNo").value  = (obj == null ? "" : formatNumberDigits(nvl(obj.distSeqNo,""), 5));
	$("distStat").value   = (obj == null ? "" : unescapeHTML2(nvl(obj.distDesc,"")));
	$("totTsi").value     = (obj == null ? "" : formatCurrency(nvl(obj.tsiAmt,"")));
	$("totPrem").value    = (obj == null ? "" : formatCurrency(nvl(obj.premAmt,"")));
	$("totFacTsi").value  = (obj == null ? "" : formatCurrency(nvl(obj.totFacTsi,"")));
	$("totFacPrem").value = (obj == null ? "" : formatCurrency(nvl(obj.totFacPrem,"")));
}