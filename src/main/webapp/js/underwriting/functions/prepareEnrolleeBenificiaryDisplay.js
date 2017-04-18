/*	Created by	: mark jm 06.06.2011
 * 	Description	: create the display for certain record
 * 	Parameters	: obj - record
 */
function prepareEnrolleeBenificiaryDisplay(obj){
	try{
		var benNo		= obj == null ? "&nbsp;" : parseInt(obj.beneficiaryNo).toPaddedString(5);
		var name		= obj == null ? "&nbsp;" : nvl(obj.beneficiaryName, "") == "" ? "&nbsp;" : escapeHTML2(obj.beneficiaryName).truncate(30, "..."); 
		var address		= obj == null ? "&nbsp;" : nvl(obj.beneficiaryAddr, "") == "" ? "&nbsp;" : escapeHTML2(obj.beneficiaryAddr).truncate(30, "...");
		var dateOfBirth	= obj == null ? "&nbsp;" : nvl(obj.dateOfBirth, "") == "" ? "&nbsp;" : dateFormat(obj.dateOfBirth, "mm-dd-yyyy");
		var age			= obj == null ? "&nbsp;" : nvl(obj.age, "") == "" ? "&nbsp;" : obj.age;
		var relation	= obj == null ? "&nbsp;" : nvl(obj.relation, "") == "" ? "&nbsp;" : escapeHTML2(obj.relation).truncate(30, "...");
			
		var content =
			'<label style="text-align: left; width: 80px; margin-right: 10px; margin-left: 5px;">' + benNo + '</label>' +
			'<label style="text-align: left; width: 190px; margin-right: 10px;">' + name + '</label>' +
			'<label style="text-align: left; width: 190px; margin-right: 10px;">' + address + '</label>' +
			'<label style="text-align: left; width: 100px; margin-right: 10px;">' + dateOfBirth + '</label>' +
			'<label style="text-align: left; width: 100px; margin-right: 10px;">' + age + '</label>' +
			'<label style="text-align: left; width: 100px; margin-right: 10px;">' + relation + '</label>';

		return content;				
	}catch(e){
		showErrorMessage("prepareEnrolleeBeneficiaryDisplay", e);
	}
}