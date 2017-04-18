/*	Created by	: mark jm 10.01.2010
 * 	Description	: returns a string containing the elements to display in table listing
 * 	Parameter	: obj - object to get data from
 */
function prepareCasualtyPersonnel(obj){
	try{
		var personnelNo 	= (obj == null ? "---" : parseInt(obj.personnelNo).toPaddedString(9));
		var personnelName 	= (obj == null ? "---" : (obj.personnelName == null || obj.personnelName.empty() ? "---" : obj.personnelName.truncate(100, "...")));		
		var amount 			= (obj == null ? "---" : (obj.amountCovered == null ? "---" : formatCurrency(obj.amountCovered)));
		
		var casualtyPersonnelInfo = 
			'<label title="' + personnelNo + '" style="width: 120px; margin-right: 10px; text-align: right;">' + personnelNo + '</label>' +
			'<label title="' + personnelName + '" style="width: 420px; padding-left: 20px;" >' + personnelName + '</label>' +			
			'<label title="' + amount + '" style="width: 280px; text-align: right;">' + amount + '</label>';
		
		return casualtyPersonnelInfo;
	}catch(e){
		showErrorMessage("prepareCasualtyPersonnel", e);
		//showMessageBox("prepareCasualtyPersonnel : " + e.message);
	}
}