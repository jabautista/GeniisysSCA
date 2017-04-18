/*	Created by	: mark jm 12.21.2010
 * 	Description	: returns a string containing the elements to display in table listing
 * 	Parameter	: obj - object to get data from
 */
function prepareMortgagee(obj){
	try{			
		var itemNo 		= (obj == null ? "---" : parseInt(obj.itemNo).toPaddedString(9));
		var mortgName 	= (obj == null ? "---" : unescapeHTML2(obj.mortgName));
		var mortgAmt 	= (obj == null ? "---" : (obj.amount == null) ? "" : formatCurrency(obj.amount));
		
		var content = 
			'<label title="' + obj.itemNo + '" style="width: 80px; text-align: right; margin-right: 10px;">' + itemNo + '</label>' +					
			'<label title="' + mortgName + '" style="width: 460px; padding-left: 20px;">' + mortgName + '</label>' +
			'<label title="' + mortgAmt + '" style="width: 280px; text-align: right;">' + mortgAmt + '</label>';	

		return content;
	}catch(e){
		showErrorMessage("prepareMortgagee", e);
		//showMessageBox("prepareMortgagee : " + e.message);
	}
}