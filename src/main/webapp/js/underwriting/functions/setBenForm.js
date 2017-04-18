function setBenForm(obj) {
	try {
		$("beneficiaryNo").value			= obj == null ? "" : obj.beneficiaryNo;
		$("beneficiaryName").value 			= obj == null ? "" : obj.beneficiaryName;
		$("beneficiaryAddr").value 			= obj == null ? "" : obj.beneficiaryAddr;
		$("beneficiaryDateOfBirth").value 	= obj == null ? "" : (obj.dateOfBirth == null ? 
												"" : dateFormat(obj.dateOfBirth, "mm-dd-yyyy"));
		$("beneficiaryAge").value 			= obj == null ? "" : obj.age == null ? "" : obj.age;
		$("beneficiaryRelation").value 		= obj == null ? "" : obj.relation;
		$("beneficiaryRemarks").value 		= obj == null ? "" : obj.remarks;		 
		
		if(obj == null){
			$("btnAddBeneficiary").value = "Add";
			disableButton($("btnDeleteBeneficiary"));
		}else{
			$("btnAddBeneficiary").value = "Update";
			enableButton($("btnDeleteBeneficiary"));
		}
	}catch(e){
		showErrorMessage("setBenForm", e);		
	}
}