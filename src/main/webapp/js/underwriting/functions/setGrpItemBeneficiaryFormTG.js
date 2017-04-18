/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	10.04.2011	mark jm			set values on grouped item beneficiary form (tablegrid version)
 * 	11.18.2011	mark jm			remove changed attribute by invoking
 */
function setGrpItemBeneficiaryFormTG(obj) {
	try {
		$("bBeneficiaryNo").value	= obj == null ? getNextAddlInfoSequenceNo(objGIPIWGrpItemsBeneficiary, $F("itemNo"), "beneficiaryNo") : obj.beneficiaryNo;
		$("bBeneficiaryName").value	= obj == null ? "" : unescapeHTML2(obj.beneficiaryName);
		$("bBeneficiaryAddr").value	= obj == null ? "" : unescapeHTML2(obj.beneficiaryAddr);
		$("bDateOfBirth").value 	= obj == null ? "" : (obj.dateOfBirth == null ? "" : dateFormat(obj.dateOfBirth, "mm-dd-yyyy"));
		$("bAge").value 			= obj == null ? "" : obj.age;
		$("bSex").value				= obj == null ? "" : obj.sex;
		$("bRelation").value 		= obj == null ? "" : unescapeHTML2(obj.relation);
		$("bCivilStatus").value		= obj == null ? "" : obj.civilStatus;				
		//edited by MarkS SR21720 8.31.2016 to disable beneficiary no. when updating 
		if(obj == null){
			$("btnAddGrpBeneficiary").value = "Add";
			$("bBeneficiaryNo").disabled= false;
			$("bBeneficiaryNo").addClassName("required applyWholeNosRegExp");
			disableButton($("btnDeleteGrpBeneficiary"));
		}else{
			$("bBeneficiaryNo").disabled= true;
			$("bBeneficiaryNo").removeClassName("required applyWholeNosRegExp");
			$("btnAddGrpBeneficiary").value = "Update";
			enableButton($("btnDeleteGrpBeneficiary"));
		}
		//END SR21720
		($$("div#accBeneficiaryInfo [changed=changed]")).invoke("removeAttribute", "changed");
	} catch(e) {
		showErrorMessage("setGrpItemBeneficiaryFormTG", e);			
	}
}