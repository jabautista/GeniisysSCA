/*	Created by	: mark jm 06.06.2011
 * 	Description	: set the display for accident beneficiary form pop-up
 * 	Parameters	: obj - record
 */
function setBBenForm(obj) {
	try {
		$("bBeneficiaryNo").value	= obj == null ? "" : obj.beneficiaryNo;
		$("bBeneficiaryName").value = obj == null ? "" : obj.beneficiaryName;
		$("bBeneficiaryAddr").value = obj == null ? "" : obj.beneficiaryAddr;
		$("bDateOfBirth").value 	= obj == null ? "" : (obj.dateOfBirth == null ? "" : dateFormat(obj.dateOfBirth, "mm-dd-yyyy"));
		$("bAge").value 			= obj == null ? "" : obj.age;
		$("bSex").value				= obj == null ? "" : obj.sex;
		$("bRelation").value 		= obj == null ? "" : obj.relation;
		$("bCivilStatus").value		= obj == null ? "" : obj.civilStatus;
		//$("bBeneficiaryRemarks").value 	= obj == null ? "" : obj.remarks;		
		
		obj == null ? $("btnAddBeneficiary").value = "Add" : $("btnAddBeneficiary").value = "Update";
		obj == null ? disableButton($("btnDeleteBeneficiary")) : enableButton($("btnDeleteBeneficiary"));
	} catch(e) {
		showErrorMessage("setBBenForm", e);			
	}
}