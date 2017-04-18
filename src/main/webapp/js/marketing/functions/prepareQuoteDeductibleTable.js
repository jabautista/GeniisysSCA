/** 
 * Prepares content of quote deductible row 
 * @param deductibleObj - JSON Object that contains the quote deductible information
 */

function prepareQuoteDeductibleTable(deductibleObj){
	var itemNo 			= deductibleObj.itemNo == null ? "---" : parseInt(deductibleObj.itemNo);
	var perilName 		= deductibleObj.perilName == null ||  deductibleObj.perilName.empty() ? "&nbsp;" : unescapeHTML2(deductibleObj.perilName).truncate(25, "...");
	var deductibleTitle = deductibleObj.deductibleTitle == null || deductibleObj.deductibleTitle.empty() ? "&nbsp;" : unescapeHTML2(deductibleObj.deductibleTitle).truncate(25, "...");
	var deductibleText 	= deductibleObj.deductibleText == null || deductibleObj.deductibleText.empty() ? "&nbsp;" : unescapeHTML2(deductibleObj.deductibleText).truncate(20, "...");
	var dedRate 		= deductibleObj.deductibleRate == null || nvl(deductibleObj.deductibleRate, "") == "" ? "---" : formatToNineDecimal(deductibleObj.deductibleRate);
	var dedAmt 			= deductibleObj.deductibleAmt == null || nvl(deductibleObj.deductibleAmt, "") == "" ? "---" : formatCurrency(deductibleObj.deductibleAmt);

	var deductInfo = '<label id="dedItemNo" style="width: 65px; text-align: center;">' +itemNo+'</label>' + 
					 '<label id="dedPerilName" style="width: 180px; text-align: left;" title="'+ changeSingleAndDoubleQuotes2(nvl(deductibleObj.perilName, "")) +'">' + perilName+ '</label>' +
					 '<label id="dedTitle" style="width: 180px; text-align: left;" title="' + changeSingleAndDoubleQuotes2(nvl(deductibleObj.deductibleTitle, "")) + '">' + deductibleTitle + '</label>' +
					 '<label id="dedText" style="width: 150px; text-align: left; padding-left: 20px;" title="'+ changeSingleAndDoubleQuotes2(nvl(deductibleObj.deductibleText, "")) +'">'+deductibleText +'</label>' +
					 '<label id="dedRate" style="width: 130px; text-align: right;">' +dedRate+ '</label>' +
					 '<label id="dedAmount" style="width: 135px; text-align: right; margin-right: 10px;">' + dedAmt + '</label>';
	
	return deductInfo;
}