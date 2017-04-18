/*	Created by	: mark jm 05.12.2011
 * 	Description	: create the display row
 * 	Parameters	: obj - record
 */
function prepareCoverageDisplay(obj){
	try{
		var grpItemTitle 	= obj.groupedItemTitle == null ? "---" : escapeHTML2(obj.groupedItemTitle).truncate(25, "...");
		var perilName 		= obj.perilName == null ? "---" : escapeHTML2(obj.perilName).truncate(25, "...");
		var premRt 			= obj.premRt == null ? "---" : formatToNineDecimal(obj.premRt);
		var tsiAmt 			= obj.tsiAmt == null ? "---" : formatCurrency(obj.tsiAmt);
		var premAmt 		= obj.premAmt == null ? "---" : formatCurrency(obj.premAmt);
		var noOfDays 		= obj.noOfDays == null ? "---" : obj.noOfDays;
		var baseAmt 		= obj.baseAmt == null ? "---" : obj.baseAmt;
		var aggregateSw 	= obj.aggregateSw == "Y" ? '<img name="checkedImg" class="printCheck" src="'+checkImgSrc+'" style="width: 10px; height: 10px; text-align: left; display: block; margin-left: 5px;" />'  : "&nbsp;";
				
		var content = 
			'<label style="text-align: left; width: 180px; margin-right: 6px; margin-left: 5px;">' + grpItemTitle + '</label>' +
			'<label style="text-align: left; width: 180px; margin-right: 6px;">' + perilName + '</label>' +
			'<label style="text-align: right; width: 100px; margin-right: 5px;">' + premRt + '</label>' +
			'<label style="text-align: right; width: 150px; margin-right: 5px;">' + tsiAmt + '</label>' +
			'<label style="text-align: right; width: 150px; margin-right: 5px;">' + premAmt + '</label>' +				
			'<label style="text-align: center; width: 20px; margin-left: 10px;">' + aggregateSw + '</label>';
			
		return content;
	}catch(e){
		showErrorMessage("prepareCoverageDisplay", e);
	}
}