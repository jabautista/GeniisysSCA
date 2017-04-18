function setACGroupedForm(obj) {
	try {
		$("groupedItemNo").value 		= obj == null ? "" : obj.groupedItemNo;
		$("groupedItemTitle").value 	= obj == null ? "" : obj.groupedItemTitle;
		$("principalCd").value			= obj == null ? "" : obj.principalCd;
		$("grpPackBenCd").value			= obj == null ? "" : obj.packBenCd;
		$("paytTerms").value			= obj == null ? "" : obj.paytTermsDesc;		
		$("grpFromDate").value	= obj == null ? "" : (obj.fromDate == null ?
											"" : dateFormat(obj.fromDate, "mm-dd-yyyy"));
		$("grpToDate").value		= obj == null ? "" : (obj.toDate == null ?
											"" : dateFormat(obj.toDate, "mm-dd-yyyy"));

		$("grpSex").value					= obj == null ? "" : obj.sex;
		$("controlTypeCd").value		= obj == null ? "" : obj.controlTypeCd;
		$("grpDateOfBirth").value			= obj == null ? "" : (obj.dateOfBirth == null ? 
											"" : dateFormat(obj.dateOfBirth, "mm-dd-yyyy"));
		$("grpAge").value				= obj == null ? "" : obj.age;
		$("controlCd").value			= obj == null ? "" : obj.controlCd;
		$("civilStatus").value			= obj == null ? "" : obj.civilStatus;
		$("grpSalary").value				= obj == null ? "" : obj.salary;
		$("grpPositionCd").value			= obj == null ? "" : obj.positionCd;
		$("salaryGrade").value			= obj == null ? "" : obj.salaryGrade;
		$("groupCd").value				= obj == null ? "" : obj.groupCd;
		$("amountCovered").value		= obj == null ? "" : obj.amountCovered;
		
		$("grpIncludeTag").value		= obj == null ? "" : obj.includeTag;
		$("grpRemarks").value			= obj == null ? "" : obj.remarks;
		$("grpLineCd").value			= obj == null ? "" : obj.lineCd;
		$("grpSublineCd").value			= obj == null ? "" : obj.sublineCd;
		$("grpDeleteSw").value			= obj == null ? "" : obj.deleteSw;
		$("grpAnnTsiAmt").value			= obj == null ? "" : obj.annTsiAmt;
		$("grpTsiAmt").value			= obj == null ? "" : obj.tsiAmt;
		$("grpPremAmt").value			= obj == null ? "" : obj.premAmt;

		(obj == null ? $("btnAddGroupedItems").value = "Add" : $("btnAddGroupedItems").value = "Update");
		(obj == null ? disableButton($("btnDeleteGroupedItems")) : enableButton($("btnDeleteGroupedItems")));
		
	} catch(e) {
		showErrorMessage("setACGroupedform", e);
	}
}