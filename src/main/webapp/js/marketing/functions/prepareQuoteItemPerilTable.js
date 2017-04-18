/** 
 * Prepares content of quote item peril row 
 * @param perilObj - JSON Object that contains the quote item peril information
 */

function prepareQuoteItemPerilTable(perilObj){
	var perilName 		= perilObj.perilName == null || perilObj.perilName == "" ? "&nbsp;" : unescapeHTML2(perilObj.perilName).truncate(20, "...");
	var perilRate 		= perilObj.perilRate == null || perilObj.perilRate == "" ? "---" : formatToNineDecimal(perilObj.perilRate);
	var tsiAmount 		= perilObj.tsiAmount == null || perilObj.tsiAmount == "" ? "---" : formatCurrency(perilObj.tsiAmount);
	var premiumAmount 	= perilObj.premiumAmount == null || perilObj.premiumAmount == "" ? "---" : formatCurrency(perilObj.premiumAmount);
	var compRem 		= perilObj.compRem == null || perilObj.compRem.empty() ? "&nbsp;" : unescapeHTML2(perilObj.compRem).truncate(35, "...");
	
	var perilInfo = 
		  '<label style="width: 25%; text-align: left; padding-left: 40px;">'+ perilName + '</label>'+
		  '<label style="width: 9%; text-align: right;">' + perilRate + '</label>'+
		  '<label style="width: 13%; text-align: right;">' + tsiAmount + '</label>'+
		  '<label style="width: 15%; text-align: right;">' + premiumAmount + '</label>'+
		  '<label style="width: 30%; text-align: left; padding-left: 10px;">' + compRem +'</label>';
   
   return perilInfo;
}