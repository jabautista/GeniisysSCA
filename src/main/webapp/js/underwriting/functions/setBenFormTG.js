/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	09.30.2011	mark jm			set values on accident beneficiary form (tablegrid version)
 * 	11.18.2011	mark jm			remove changed attribute by invoking
 */
function setBenFormTG(obj) {
	try {
		$("beneficiaryNo").value			= obj == null ? getNextAddlInfoSequenceNo(objBeneficiaries, $F("itemNo"), "beneficiaryNo") : obj.beneficiaryNo;
		$("beneficiaryName").value 			= obj == null ? "" : unescapeHTML2(obj.beneficiaryName);
		$("beneficiaryAddr").value 			= obj == null ? "" : unescapeHTML2(obj.beneficiaryAddr);
		$("beneficiaryDateOfBirth").value 	= obj == null ? "" : (obj.dateOfBirth == null ? 
												"" : dateFormat(obj.dateOfBirth, "mm-dd-yyyy"));
		$("beneficiaryAge").value 			= obj == null ? "" : obj.age;
		$("beneficiaryRelation").value 		= obj == null ? "" : unescapeHTML2(obj.relation);
		$("beneficiaryRemarks").value 		= obj == null ? "" : unescapeHTML2(obj.remarks);		 
		
		if(obj == null){
			$("btnAddBeneficiary").value = "Add";
			disableButton($("btnDeleteBeneficiary"));
		}else{
			$("btnAddBeneficiary").value = "Update";
			enableButton($("btnDeleteBeneficiary"));
		}
		
		($$("div#beneficiaryInformationInfo [changed=changed]")).invoke("removeAttribute", "changed");
	}catch(e){
		showErrorMessage("setBenFormTG", e);		
	}
}