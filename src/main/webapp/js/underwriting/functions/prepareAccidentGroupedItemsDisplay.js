/*	Created by	: mark jm 06.06.2011
 * 	Description	: create the display for certain record
 * 	Parameters	: obj - record
 */
function prepareAccidentGroupedItemsDisplay(obj){
	try{			
		var groupedItemNo		= obj == null ? "---" : parseInt(obj.groupedItemNo).toPaddedString(9);
		var groupedItemTitle	= obj == null ? "---" : escapeHTML2(obj.groupedItemTitle).truncate(25, '...');
		var principalCd			= obj == null ? "---" : nvl(obj.principalCd, "---");
		var planDesc			= obj == null ? "---" : escapeHTML2(nvl(obj.paytTermsDesc, "---")).truncate(15, '...');
		var paymentDesc			= obj == null ? "---" : escapeHTML2(nvl(obj.paytTermsDesc, "---")).truncate(15, '...');
		var fromDate			= obj == null ? "---" : obj.fromDate != null ? (obj.strFromDate == undefined ? dateFormat(obj.fromDate, "mm-dd-yyyy") : dateFormat(obj.strFromDate, "mm-dd-yyyy")) : "---";
		var toDate				= obj == null ? "---" : obj.toDate != null ? (obj.strToDate == undefined ? dateFormat(obj.toDate, "mm-dd-yyyy") : dateFormat(obj.strToDate, "mm-dd-yyyy")) : "---";
		var deleteSw			= obj == null ? "" : obj.deleteSw == "Y" ? '<img name="checkedImg" class="printCheck" src="'+checkImgSrc+'" style="width: 10px; height: 10px; text-align: left; display: block; margin-left: 5px;" />'  : "&nbsp;";
		
		var content = 
			'<label style="text-align: right; width: 20px; margin-right: 2px;">' + deleteSw + '</label>' +
			'<label name="textG" style="text-align: left; width: 90px; margin-right: 2px;">' + groupedItemNo + '</label>'+
			'<label name="textG" style="text-align: left; width: 210px; margin-right: 2px;">' + groupedItemTitle + '</label>'+
			'<label name="textG" style="text-align: left; width: 90px; margin-right: 0px;">' + principalCd + '</label>'+
			'<label name="textG" style="text-align: left; width: 100px; margin-right: 4px;">' + planDesc+ '</label>'+
			'<label name="textG" style="text-align: left; width: 100px; margin-right: 2px;">' + paymentDesc + '</label>'+
			'<label name="textG" style="text-align: left; width: 100px; margin-right: 3px;">' + fromDate + '</label>'+
			'<label name="textG" style="text-align: left; width: 100px; margin-right: 2px;">' + toDate + '</label>';

		return content;
	}catch(e){
		showErrorMessage("prepareAccidentGroupedItemsDisplay", e);
	}
}