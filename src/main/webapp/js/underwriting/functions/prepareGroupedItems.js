/*	Created by	: mark jm 10.01.2010
 * 	Description : returns a string containing the elements to display in table listing
 * 	Parameter	: obj - object to get data from
 */
function prepareGroupedItems(obj){
	try{
		var groupedItemNo 		= (obj == null ? "---" : parseInt(obj.groupedItemNo).toPaddedString(9));
		var groupedItemTitle 	= (obj == null ? "---" : (obj.groupedItemTitle == null || obj.groupedItemTitle.empty() ? "---" : obj.groupedItemTitle.truncate(100, "...")));		
		var amount 				= (obj == null ? "---" : (obj.amountCovered == null ? "---" : formatCurrency(obj.amountCovered)));
			
		var groupedItemInfo = 
			'<label title="' + groupedItemNo + '" style="width: 120px; margin-right: 10px; text-align: right;">' + groupedItemNo + '</label>' + 
			'<label title="' + groupedItemTitle + '" style="width: 420px; padding-left: 20px;">' + groupedItemTitle + '</label>' +			
			'<label title="' + amount + '" style="width: 280px; text-align: right;" >' + amount + '</label>';
		
		return groupedItemInfo;
	}catch(e){
		showErrorMessage("prepareGroupedItems", e);
		//showMessageBox("prepareGroupedItems : " + e.message);
	}
}