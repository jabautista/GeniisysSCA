function setGrpBenForm(obj) {
	try {
		$("bBeneficiaryNo").value		=	obj == null ? "" : obj.beneficiaryNo;
		$("bBeneficiaryName").value		= 	obj == null ? "" : obj.beneficiaryName;	
		$("bBeneficiaryAddr").value		= 	obj == null ? "" : obj.beneficiaryAddr;	
		$("bAge").value					=	obj == null ? "" : obj.age;
		$("bSex").value					=	obj == null ? "" : obj.sex;
		$("bRelation").value			=	obj == null ? "" : obj.relation;
		$("bCivilStatus").value			=	obj == null ? "" : obj.civilStatus;
		//edited by MarkS SR21720 8.31.2016
		if(obj==null){
			$("btnAddGrpBeneficiary").value = "Add";
			$("bBeneficiaryNo").disabled= false;
			$("bBeneficiaryNo").addClassName("required applyWholeNosRegExp");
			disableButton($("btnDeleteGrpBeneficiary"))
		} else{
			$("btnAddGrpBeneficiary").value = "Update";
			$("bBeneficiaryNo").disabled= true;
			$("bBeneficiaryNo").removeClassName("required applyWholeNosRegExp");
			enableButton($("btnDeleteGrpBeneficiary"))
		}
		//END SR21720
	} catch(e) {
		showErrorMessage("setGrpBenForm", e);
	}
}