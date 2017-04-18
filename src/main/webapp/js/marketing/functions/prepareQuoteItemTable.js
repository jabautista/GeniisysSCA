/** 
 * Prepares content of quote item row 
 * @param obj - JSON Object that contains the quote item information
 */

function prepareQuoteItemTable(obj){
	var itemNo 			= obj.itemNo == null ? "---" : parseInt(obj.itemNo);
	var itemTitle 		= obj.itemTitle == null || obj.itemTitle.empty() ? "&nbsp;" : unescapeHTML2(obj.itemTitle).truncate(15, "...");
	var itemDesc 		= obj.itemDesc == null || obj.itemDesc.empty() ? "&nbsp;" : unescapeHTML2(obj.itemDesc).truncate(15, "...");
	var itemDesc2 		= obj.itemDesc2 == null || obj.itemDesc2.empty() ? "&nbsp;" : unescapeHTML2(obj.itemDesc2).truncate(15, "...");
	var currencyDesc 	= obj.currencyDesc == null || obj.currencyDesc.empty() ? "---" : obj.currencyDesc.truncate(15, "...");
	var currencyRate 	= obj.currencyRate == null || obj.currencyRate == "" ? "---" : formatToNineDecimal(obj.currencyRate);
	var coverageDesc 	= obj.coverageDesc == null || obj.coverageDesc.empty() ? "---" : unescapeHTML2(obj.coverageDesc).truncate(15, "...");

	var itemInfo  = '<label style="width: 5%; text-align: center; margin-left: 15px;" title="' + obj.itemNo + '"name="quoteItemNo">' + itemNo + '</label>' +						
					'<label style="width: 14.5%; text-align: left;" title="' + changeSingleAndDoubleQuotes2(nvl(obj.itemTitle, ""))+ '" name="quoteItemTitle">' + itemTitle + '</label>'+
					'<label style="width: 14%; text-align: left; margin-left: 10px;" title="' + changeSingleAndDoubleQuotes2(nvl(obj.itemDesc, ""))+ '" name="quoteItemDesc1">' + itemDesc + '</label>' +
					'<label style="width: 14%; text-align: left; margin-left: 10px;" title="' + changeSingleAndDoubleQuotes2(nvl(obj.itemDesc2, ""))+ '" name="quoteItemDesc2">' + itemDesc2 + '</label>' +
					'<label style="width: 16%; text-align: left; margin-left: 10px;" title="' + obj.currencyDesc + '">' + currencyDesc + '</label>' +
					'<label style="width: 8%; text-align: right;" title="' + currencyRate + '" >' + currencyRate + '</label>'+
					'<label style="width: 19%; text-align: left; margin-left: 15px;" title="'+changeSingleAndDoubleQuotes2(nvl(obj.coverageDesc, ""))+'">' + coverageDesc +'</label>';
					
	return itemInfo;
}