/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	10.04.2011	mark jm			create an grouped item beneficiary object
 */
function setGrpItemBeneficiaryObj(){
	try{
		var newObj = new Object();

		newObj.parId			= (objUWGlobal.packParId != null ? objCurrPackPar.parId : objUWParList.parId);
		newObj.itemNo			= $F("itemNo");
		newObj.groupedItemNo	= removeLeadingZero($F("groupedItemNo"));
		newObj.beneficiaryNo	= $F("bBeneficiaryNo");
		//newObj.beneficiaryName	= changeSingleAndDoubleQuotes2($F("bBeneficiaryName"));
		newObj.beneficiaryName	= escapeHTML2($F("bBeneficiaryName")); //replaced by: Mark C. 04152015 SR4302
		//newObj.beneficiaryAddr	= changeSingleAndDoubleQuotes2($F("bBeneficiaryAddr"));
		newObj.beneficiaryAddr	= escapeHTML2($F("bBeneficiaryAddr")); //replaced by: Mark C. 04152015 SR4302
		//newObj.relation			= changeSingleAndDoubleQuotes2($F("bRelation"));
		newObj.relation			= escapeHTML2($F("bRelation")); //replaced by: Mark C. 04152015 SR4302
		newObj.dateOfBirth		= $F("bDateOfBirth").empty() ? null : $F("bDateOfBirth");
		newObj.age				= $F("bAge").empty() ? null : $F("bAge");
		newObj.civilStatus		= $F("bCivilStatus").empty() ? null : $F("bCivilStatus");
		newObj.civilStatusDesc	= $("bCivilStatus").options[$("bCivilStatus").selectedIndex].text;
		newObj.sex				= $F("bSex").empty() ? null : $F("bSex");
		
		return newObj;
		
	}catch(e){
		showErrorMessage("setGrpItemBeneficiaryObj", e);
	}
}