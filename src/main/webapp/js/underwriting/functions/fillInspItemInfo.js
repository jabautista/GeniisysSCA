function fillInspItemInfo(itemInfoObj){
	var content = "<label style='text-align: right; width: 12%;'>" + itemInfoObj.itemNo.toPaddedString(10) + "</label>" + 
				  "<label style='text-align: left; width: 25%; margin-left: 10px;'>" + nvl(unescapeHTML2(itemInfoObj.itemTitle), "---").truncate(20, "...") + "</label>" + //added by steven 11/26/2012 -> unescapeHTML2
	              "<label style='text-align: left; width: 25%; margin-left: 10px;'>" + nvl(unescapeHTML2(itemInfoObj.itemDesc), "&nbsp").truncate(25, "...") + "</label>" + //change by steven 10/30/2012 from: "---"  to:"&nbsp" 
				  "<label style='text-align: right; width: 16%; margin-left: 10px;'>" + formatCurrency(nvl(itemInfoObj.tsiAmt, 0)) + "</label>" +
				  "<label style='text-align: right; width: 16%; margin-left: 10px;'>" + formatToNineDecimal(nvl(itemInfoObj.premRate, 0)) + "</label>";

	return content;
}