/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	09.30.2011	mark jm			set values on accident grouped items form (tablegrid version)
 * 	11.18.2011	mark jm			remove changed attribute by invoking
 */
function setACGroupedItemFormTG(obj) {
	try {
		$("groupedItemNo").value 	= obj == null ? "" : obj.groupedItemNo;
		$("groupedItemTitle").value = obj == null ? "" : unescapeHTML2(obj.groupedItemTitle); // andrew - 06.18.2012 - added unescapeHTML2
		$("principalCd").value		= obj == null ? "" : obj.principalCd;
		$("grpPackBenCd").value		= obj == null ? "" : obj.packBenCd;
		$("paytTerms").value		= obj == null ? "" : obj.paytTerms;		
		$("grpFromDate").value		= obj == null ? "" : (obj.fromDate == null ? "" : dateFormat(obj.fromDate, "mm-dd-yyyy"));
		$("grpToDate").value		= obj == null ? "" : (obj.toDate == null ?	"" : dateFormat(obj.toDate, "mm-dd-yyyy"));

		$("grpSex").value			= obj == null ? "" : obj.sex;
		$("controlTypeCd").value	= obj == null ? "" : obj.controlTypeCd;
		$("grpDateOfBirth").value	= obj == null ? "" : (obj.dateOfBirth == null ? "" : dateFormat(obj.dateOfBirth, "mm-dd-yyyy"));
		$("grpAge").value			= obj == null ? "" : obj.age;
		//$("controlCd").value		= obj == null ? "" : obj.controlCd;
		$("controlCd").value		= obj == null ? "" : unescapeHTML2(obj.controlCd); //replaced by: Mark C 03.11.2015 SR4302
		$("civilStatus").value		= obj == null ? "" : obj.civilStatus;
		$("grpSalary").value		= obj == null ? "" : (obj.salary == null ? "" : formatCurrency(obj.salary));
		$("grpPositionCd").value	= obj == null ? "" : obj.positionCd;
		//$("salaryGrade").value		= obj == null ? "" : obj.salaryGrade;
		$("salaryGrade").value		= obj == null ? "" : unescapeHTML2(obj.salaryGrade); //replaced by: Mark C 03.11.2015 SR4302
		$("groupCd").value			= obj == null ? "" : obj.groupCd;
		$("amountCovered").value	= obj == null ? "" : (obj.amountCovered == null ? "" : formatCurrency(obj.amountCovered));
		
		$("grpIncludeTag").value	= obj == null ? "Y" : obj.includeTag;
		$("grpRemarks").value		= obj == null ? "" : obj.remarks;
		$("grpLineCd").value		= obj == null ? (objUWGlobal.packParId != null ? objCurrPackPar.lineCd : objUWParList.lineCd) : obj.lineCd;
		$("grpSublineCd").value		= obj == null ? "" : obj.sublineCd;
		$("grpDeleteSw").value		= obj == null ? "" : obj.deleteSw;
		$("grpAnnTsiAmt").value		= obj == null ? "" : obj.annTsiAmt;
		$("grpTsiAmt").value		= obj == null ? "" : obj.tsiAmt;
		$("grpPremAmt").value		= obj == null ? "" : obj.premAmt;
		
		$("btnAddGroupedItems").value = obj == null ?  "Add" : "Update";
		
		$("grpFromDate").setAttribute("lastValidValue", $F("grpFromDate").blank() ? "" : $F("grpFromDate"));
		$("grpToDate").setAttribute("lastValidValue", $F("grpToDate").blank() ? "" : $F("grpToDate"));
		
		if(obj == null){
			//disableButton($("btnPopulateBenefits"));
			disableButton($("btnDeleteBenefits"));			
			disableButton($("btnDeleteGroupedItems"));
			$("groupedItemNo").removeAttribute("readonly");
		}else{
			//enableButton($("btnPopulateBenefits"));
			enableButton($("btnDeleteBenefits"));			
			enableButton($("btnDeleteGroupedItems"));
			$("groupedItemNo").setAttribute("readonly", "readonly");
		}
		
		($$("div#groupedItemsDetail [changed=changed]")).invoke("removeAttribute", "changed");
	} catch(e) {
		showErrorMessage("setACGroupedItemFormTG", e);
	}
}