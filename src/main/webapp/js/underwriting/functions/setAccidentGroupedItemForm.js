/*	Created by	: mark jm 06.06.2011
 * 	Description	: set accident grouped items pop-up form display
 * 	Parameters	: obj - record
 * 				: fromAjax - flag if record is from an ajax request	
 */
function setAccidentGroupedItemForm(obj, fromAjax){
	try{		
		$("groupedItemNo").value 	= obj == null ? "" : formatNumberDigits(obj.groupedItemNo, 7);
		$("groupedItemTitle").value = obj == null ? "" : obj.groupedItemTitle;
		$("principalCd").value 		= obj == null ? "" : obj.principalCd != null ? formatNumberDigits(obj.principalCd, 7) : "" ;
		$("packBenCd").value 		= obj == null ? "" : obj.packBenCd;
		$("paytTerms").value 		= obj == null ? "" : obj.paytTerms;
		$("grpFromDate").value 		= obj == null ? "" : obj.fromDate == null ? "" : (obj.strFromDate == undefined ? dateFormat(obj.fromDate, "mm-dd-yyyy") : dateFormat(obj.strFromDate, "mm-dd-yyyy")); //change by steven 9/4/2012 from: fromDate to: strFromDate
		$("grpToDate").value 		= obj == null ? "" : obj.toDate == null ? "" : (obj.strToDate == undefined ? dateFormat(obj.toDate, "mm-dd-yyyy") : dateFormat(obj.strToDate, "mm-dd-yyyy"));	//change by steven 9/4/2012 from: fromDate to: strFromDate
		$("sex").value 				= obj == null ? "" : obj.sex;
		$("dateOfBirth").value 		= obj == null ? "" : obj.dateOfBirth == null ? "" : (obj.strDateOfBirth == undefined ? dateFormat(obj.dateOfBirth, "mm-dd-yyyy") :  dateFormat(obj.strDateOfBirth, "mm-dd-yyyy"));	//change by steven 9/4/2012 from: fromDate to: strFromDate
		$("age").value 				= obj == null ? "" : obj.age;
		$("civilStatus").value 		= obj == null ? "" : obj.civilStatus;
		$("positionCd").value 		= obj == null ? "" : obj.positionCd;
		$("groupCd").value 			= obj == null ? "" : obj.groupCd;
		$("controlTypeCd").value 	= obj == null ? "" : obj.controlTypeCd;
		$("controlCd").value 		= obj == null ? "" : obj.controlCd;
		$("salary").value 			= obj == null ? "" : formatCurrency(nvl(obj.salary, ""));
		$("salaryGrade").value 		= obj == null ? "" : obj.salaryGrade;
		$("amountCovered").value 	= obj == null ? "" : formatCurrency(nvl(obj.amountCovered, ""));
		$("includeTag").value 		= obj == null ? "" : obj.includeTag;
		$("remarks").value 			= obj == null ? "" : obj.remarks;
		$("lineCd").value 			= obj == null ? "" : obj.lineCd;
		$("sublineCd").value 		= obj == null ? "" : obj.sublineCd;
		$("deleteSw").checked 		= obj == null ? "" : nvl(obj.deleteSw, "N") == "N" ? false : true;
		$("gAnnTsiAmt").value 		= obj == null ? "" : formatCurrency(obj.annTsiAmt);
		$("gAnnPremAmt").value 		= obj == null ? "" : formatCurrency(obj.annPremAmt);
		$("gTsiAmt").value 			= obj == null ? "" : formatCurrency(obj.tsiAmt);
		$("gPremAmt").value 		= obj == null ? "" : formatCurrency(obj.premAmt);			

		if(!fromAjax){
			$("btnAddGroupedItems").value	= obj == null ? "Add" : "Update";		 
			
			if(obj == null){
				disableButton($("btnDeleteGroupedItems"));
				enableButton($("btnRetrieveGrpItems"));
				$("deleteSw").disable();
			}else{
				enableButton($("btnDeleteGroupedItems"));
				disableButton($("btnRetrieveGrpItems"));
				$("deleteSw").enable();										
			}
		}	
	}catch(e){
		showErrorMessage("setAccidentGroupedItemForm", e);
	}
}