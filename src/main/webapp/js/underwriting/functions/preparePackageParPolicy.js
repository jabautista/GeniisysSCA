/*	Created by	: mark jm 03.17.2011
 * 	Description	: create the display of record list
 * 	Parameters	: obj - contains data for display
 */
function preparePackageParPolicy(obj){
	try{
		var parNo 		= obj.parNo == null ? "---" : obj.parNo;
		var lineName	= obj.lineName == null ? "---" : obj.lineName;
		var sublineName	= obj.sublineName == null ? "---" : obj.sublineName;
		
		var content = 
				'<label title="' + parNo + '" style="width: 330px; text-align: left; margin-left: 5px;">' + parNo + '</label>' +
				'<label title="' + lineName + '" style="width: 200px; text-align: left;">' + lineName + '</label>' +
				'<label title="' + sublineName + '" style="width: 330px; text-align: left;">' + sublineName + '</label>';
	
		return content;
	}catch(e){
		showErrorMessage("preparePackageParPolicy", e);
	}
}