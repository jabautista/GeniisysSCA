function prepareEndtItemInfo(obj){
	try {
		var itemNo 			= obj.itemNo == null ? "---" : parseInt(obj.itemNo).toPaddedString(9);
		var itemTitle 		= obj.itemTitle == null || obj.itemTitle.empty() ? "&nbsp;" : unescapeHTML2(obj.itemTitle).truncate(20, "...");	// edited by d.alcantara, changed from escapeHTML2
		var itemDesc 		= obj.itemDesc == null || obj.itemDesc.empty() ? "&nbsp;" : unescapeHTML2(obj.itemDesc).truncate(20, "...");
		var itemDesc2 		= obj.itemDesc2 == null || obj.itemDesc2.empty() ? "&nbsp;" : unescapeHTML2(obj.itemDesc2).truncate(20, "...");
		var currencyDesc 	= obj.currencyDesc == null ? "---" : obj.currencyDesc.truncate(15, "...");
		var currencyRt 		= obj.currencyRt == null ? "---" : formatToNineDecimal(obj.currencyRt);

		var itemInfo  = '<label style="width: 80px; text-align: right; margin-right: 10px;" title="' + obj.itemNo + '"name="endtItemNo">' + itemNo + '</label>' +						
						'<label style="width: 180px; text-align: left;" title="' + unescapeHTML2(nvl(obj.itemTitle, "")).truncate(20, "...") + '" name="endtItemTitle">' + itemTitle + '</label>'+
						'<label style="width: 180px; text-align: left;" title="' + unescapeHTML2(nvl(obj.itemDesc, "")).truncate(20, "...") + '" name="endtItemDesc1">' + itemDesc + '</label>' +
						'<label style="width: 180px; text-align: left;" title="' + unescapeHTML2(nvl(obj.itemDesc2, "")).truncate(20, "...") + '" name="endtItemDesc2">' + itemDesc2 + '</label>' +
						'<label style="width: 120px; text-align: left;" title="' + obj.currencyDesc + '">' + currencyDesc + '</label>' +
						'<label style="width: 100px; text-align: right; margin-right: 10px;" title="' + currencyRt + '" >' + currencyRt + '</label>';
						
		return itemInfo;
	} catch (e) {
		showErrorMessage("prepareEndtItemInfo", e);
	}
}