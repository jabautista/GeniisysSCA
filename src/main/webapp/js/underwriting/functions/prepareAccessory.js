/*	Created by	: mark jm 12.21.2010
 * 	Description	: returns a string containing the elements to display in table listing
 * 	Parameter	: obj - object to get data from
 */
function prepareAccessory(obj){
	try{
		var itemNo 	= obj == null ? "---" : parseInt(obj.itemNo).toPaddedString(9);
		var accDesc	= obj == null ? "---" : obj.accessoryDesc;
		var accAmt	= obj == null ? "---" : (obj.accAmt == null ? "" : formatCurrency(obj.accAmt));

		var content = 
			'<label title="'+ itemNo +'" style="text-align: right; width: 80px; margin-right: 10px;">'+ itemNo +'</label>' +
		 	'<label title="'+ accDesc +'" style="text-align: left; width: 460px; padding-left: 20px;">'+ accDesc.truncate(100, "...") +'</label>' +
			'<label title="'+ accAmt +'" style="text-align: right; width: 280px;" class="money">'+ accAmt +'</label>';

		return content;
	}catch(e){
		showErrorMessage("prepareAccessory", e);
		//showMessageBox("prepareAccessory : " + e.message);
	}
}