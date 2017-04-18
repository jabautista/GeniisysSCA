/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	10.03.2011	mark jm			create an accident grouped item object
 */
function setAccidentGroupedItemsObj(){
	try{
		var newObj = new Object();
		
		newObj.parId 			= (objUWGlobal.packParId != null ? objCurrPackPar.parId : objUWParList.parId);
		newObj.itemNo 			= $F("itemNo");
		newObj.groupedItemNo	= $F("groupedItemNo");
		newObj.includeTag		= $F("grpIncludeTag");
		//newObj.groupedItemTitle	= changeSingleAndDoubleQuotes2($F("groupedItemTitle"));
		newObj.groupedItemTitle	= escapeHTML2($F("groupedItemTitle")); //replaced by: Mark C. 04142015 SR4302
		newObj.sex				= $F("grpSex");
		newObj.positionCd		= $F("grpPositionCd");
		newObj.civilStatus		= $F("civilStatus");
		newObj.dateOfBirth		= $F("grpDateOfBirth") == "" ? null : $F("grpDateOfBirth");
		newObj.age				= $F("grpAge");
		newObj.salary			= $F("grpSalary");
//		newObj.salaryGrade		= $F("salaryGrade");
		newObj.salaryGrade		= escapeHTML2($F("salaryGrade")); //replaced by: Mark C 03.11.2015 SR4302
		newObj.amountCovered	= $F("amountCovered");
		newObj.remarks			= changeSingleAndDoubleQuotes2($F("grpRemarks"));
		newObj.lineCd			= $F("grpLineCd");
		newObj.sublineCd		= $F("grpSublineCd");
		newObj.deleteSw			= $F("grpDeleteSw");
		newObj.groupCd			= $F("groupCd");
		newObj.packBenCd		= $F("grpPackBenCd");
		newObj.fromDate			= $F("grpFromDate") == "" ? null : $F("grpFromDate");
		newObj.toDate			= $F("grpToDate") == "" ? null : $F("grpToDate");
		newObj.paytTerms		= $F("paytTerms");
		newObj.annTsiAmt		= $F("grpAnnTsiAmt");
		newObj.annPremAmt		= $F("grpAnnPremAmt");
		//newObj.controlCd		= $F("controlCd");
		newObj.controlCd		= escapeHTML2($F("controlCd")); //replaced by: Mark C 03.11.2015 SR4302
		newObj.controlTypeCd	= $F("controlTypeCd");
		newObj.tsiAmt			= $F("grpTsiAmt");
		newObj.premAmt			= $F("grpPremAmt");
		newObj.principalCd		= $F("principalCd");
		newObj.packageCd		= $("grpPackBenCd").options[$("grpPackBenCd").selectedIndex].text;
		newObj.paytTermsDesc	= $("paytTerms").options[$("paytTerms").selectedIndex].text;

		//newObj.packageCd		= "";
		//newObj.paytTermsDesc	= "";

		return newObj;
	}catch(e){
		showErrorMessage("setAccidentGroupedItemsObj", e);
	}
}