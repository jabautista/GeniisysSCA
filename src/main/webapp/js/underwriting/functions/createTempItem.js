/**
 * Create temporary record in Item Discount in GIPIS143
 * @author Jerome Orio 02.04.2011
 * @version 1.0
 * @param 
 * @return 
 */
function createTempItem(){
	var sequenceNo = $F("sequenceNoItem");
	var itemNo = $F("itemNo").blank()?'-':$F("itemNo");
	var itemTitle = $F("itemTitle").blank()?'-':$F("itemTitle");
	var premAmt = formatCurrency($F("premAmtItem"));
	var origPremAmt = formatCurrency($F("origPremAmtItem"));
	var discountAmt = formatCurrency($F("discountAmtItem"));
	var discountRt = formatRate($F("discountRtItem"));
	var surchargeAmt = formatCurrency($F("surchargeAmtItem"));
	var surchargeRt = formatRate($F("surchargeRtItem"));
	var grossTag = $("grossTagItem").checked==true?'G':'';
	var remark = changeSingleAndDoubleQuotes2($F("remarkItem"));
	var itemTable = $("billItemDiscountTableList");

	var newDiv = new Element("div");
	newDiv.setAttribute("id", "rowItem"+sequenceNo);
	newDiv.setAttribute("name", "rowItemTempOnly");
	newDiv.setStyle("height: 20px; border-bottom: 1px solid #E0E0E0; padding-top: 10px; display: none;");

	var strDiv = ''+
		'<input type="hidden" name="itemSequenceNos" value="'+sequenceNo+'" />'+
		'<input type="hidden" name="itemItemNos" value="'+itemNo+'" />'+
		'<input type="hidden" name="itemTitles" value="'+itemTitle+'" />'+
		'<input type="hidden" name="itemNetPremAmts" value="'+premAmt+'" />'+
		'<input type="hidden" name="itemDiscountAmts" value="'+discountAmt+'" />'+
		'<input type="hidden" name="itemDiscountRts" value="'+discountRt+'" />'+
		'<input type="hidden" name="itemSurchargeAmts" value="'+surchargeAmt+'" />'+
		'<input type="hidden" name="itemSurchargeRts" value="'+surchargeRt+'" />'+
		'<input type="hidden" name="itemNetGrossTags" value="'+grossTag+'" />'+
		'<input type="hidden" name="itemRemarks" value="'+remark+'" />'+
		'<input type="hidden" name="itemOrigPremAmts" value="'+origPremAmt+'" />';

	newDiv.update(strDiv);
	itemTable.insert({bottom: newDiv});
}