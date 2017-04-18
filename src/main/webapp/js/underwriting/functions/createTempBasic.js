/**
 * Create temporary record in Policy Discount in GIPIS143
 * @author Jerome Orio 01.31.2011
 * @version 1.0
 * @param 
 * @return 
 */
function createTempBasic(){
	var sequenceNo = $F('sequenceNo');
	var premAmt = formatCurrency($F("premAmt"));
	var discountAmt = formatCurrency($F("discountAmt"));
	var discountRt = formatRate($F("discountRt"));
	var surchargeAmt = formatCurrency($F("surchargeAmt"));
	var surchargeRt = formatRate($F("surchargeRt"));
	var grossTag = $("grossTag").checked==true?'G':'';
	var remark = changeSingleAndDoubleQuotes2($F("remark"));
	var itemTable = $("billPolicyBasicDiscountTableList");
	var newDiv = new Element("div");
	newDiv.setAttribute("id", "rowBasic"+sequenceNo);
	newDiv.setAttribute("name", "rowBasicTempOnly");
	newDiv.setStyle("height: 20px; border-bottom: 1px solid #E0E0E0; padding-top: 10px; display: none;");

	var strDiv = ''+
		'<input type="hidden" name="sequenceNos" value="'+sequenceNo+'" />'+
		'<input type="hidden" name="origPremAmts" value="'+premAmt+'" />'+
		'<input type="hidden" name="discountAmts" value="'+discountAmt+'" />'+
		'<input type="hidden" name="discountRts" value="'+discountRt+'" />'+
		'<input type="hidden" name="surchargeAmts" value="'+surchargeAmt+'" />'+
		'<input type="hidden" name="surchargeRts" value="'+surchargeRt+'" />'+
		'<input type="hidden" name="netGrossTags" value="'+grossTag+'" />'+
		'<input type="hidden" name="remarks" value="'+remark+'" />';	

	newDiv.update(strDiv);
	itemTable.insert({bottom: newDiv});
}	