//steven 3.7.2012
function populateQuotationDetails(obj){
		$("quotationNo").value     = (obj) == null ? "" : unescapeHTML2(nvl(obj.quoteNo,""));
		$("quoteAssured").value    = (obj) == null ? "" : unescapeHTML2(nvl(obj.assdName,""));
		$("parAssured").value      = (obj) == null ? "" : unescapeHTML2(nvl(obj.parAssd,""));
		$("reasonForDenial").value = (obj) == null ? "" : unescapeHTML2(nvl(obj.reasonDesc,""));
		$("parNo").value           = (obj) == null ? "" : unescapeHTML2(nvl(obj.parNo,""));
		$("policyNo").value        = (obj) == null ? "" : unescapeHTML2(nvl(obj.polNo,""));
		$("inceptDate").value      = (obj) == null ? "" : unescapeHTML2(nvl(obj.inceptDate == null ? "" : dateFormat(obj.inceptDate,"mm-dd-yyyy")));
		$("expiryDate").value      = (obj) == null ? "" : unescapeHTML2(nvl(obj.expiryDate == null ? "" : dateFormat(obj.expiryDate,"mm-dd-yyyy")));
		$("packQuoteNo").value	   = (obj) == null ? "" : unescapeHTML2(nvl(obj.packQuoteNo,""));
}