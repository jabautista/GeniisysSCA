/**
 * Create temporary record in Peril Discount in GIPIS143
 * @author Jerome Orio 02.07.2011
 * @version 1.0
 * @param 
 * @return 
 */
function createTempPeril(){
	var sequenceNo = $F("sequenceNoPeril");
	var itemNo = $("itemNoPeril").value == ""?'-':$("itemNoPeril").value;
	var perilCd = $("itemPerilCd").value == ""?'-':$("itemPerilCd").value;	//$("itemPeril").value == ""?'-':$("itemPeril").value; change by steve 10/01/2012
	var perilName = $("itemPeril").value;									//$("itemPeril").options[$("itemPeril").selectedIndex].text; change by steve 10/01/2012
	var premAmt = formatCurrency($F("premAmtPeril"));
	var origPerilPremAmt = formatCurrency($F("paramOrigPerilPremAmt"));
	var discountAmt = formatCurrency($F("discountAmtPeril"));
	var discountRt = formatRate(nvl($F("discountRtPeril"),0)); //with NVL dahil not nullable sa db
	var surchargeAmt = formatCurrency($F("surchargeAmtPeril"));
	var surchargeRt = formatRate($F("surchargeRtPeril"));
	var grossTag = $("grossTagPeril").checked==true?'G':'';
	var remark = changeSingleAndDoubleQuotes2($F("remarkPeril"));
	var itemTable = $("billPerilDiscountTableList");
	var origPerilAnnPremAmt = formatCurrency($F("origPerilAnnPremAmt"));
	var origItemAnnPremAmt = formatCurrency($F("origItemAnnPremAmt"));
	var origPolAnnPremAmt = formatCurrency($F("origPolAnnPremAmt"));

	var newDiv = new Element("div");
	newDiv.setAttribute("id", "rowPeril"+sequenceNo);
	newDiv.setAttribute("name", "rowPerilTempOnly");
	newDiv.setStyle("height: 20px; border-bottom: 1px solid #E0E0E0; padding-top: 10px; display: none;");
	
	var strDiv = ''+
		'<input type="hidden" name="perilSequenceNos" value="'+sequenceNo+'" />'+
		'<input type="hidden" name="perilItemNos" value="'+itemNo+'" />'+
		'<input type="hidden" name="perilCodes" value="'+perilCd+'" />'+
		'<input type="hidden" name="perilLevelTags" value="1" />'+
		'<input type="hidden" name="perilNetPremAmts" value="'+premAmt+'" />'+
		'<input type="hidden" name="perilDiscountAmts" value="'+discountAmt+'" />'+
		'<input type="hidden" name="perilDiscountRts" value="'+discountRt+'" />'+
		'<input type="hidden" name="perilSurchargeAmts" value="'+surchargeAmt+'" />'+
		'<input type="hidden" name="perilSurchargeRts" value="'+surchargeRt+'" />'+
		'<input type="hidden" name="perilNetGrossTags" value="'+grossTag+'" />'+
		'<input type="hidden" name="perilRemarks" value="'+remark+'" />'+
		'<input type="hidden" name="perilOrigPerilPremAmt" value="'+origPerilPremAmt+'" />'+
		'<input type="hidden" name="perilOrigPerilAnnPremAmt" value="'+origPerilAnnPremAmt+'" />'+
		'<input type="hidden" name="perilOrigItemAnnPremAmt" value="'+origItemAnnPremAmt+'" />'+
		'<input type="hidden" name="perilOrigPolAnnPremAmt" value="'+origPolAnnPremAmt+'" />';	

	newDiv.update(strDiv);
	itemTable.insert({bottom: newDiv});		
}