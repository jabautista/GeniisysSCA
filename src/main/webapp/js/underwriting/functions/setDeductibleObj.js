/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	07.27.2011	mark jm			returns a new deductible object (from deductible page)
 * 								Parameters	: dedLevel - (policy, item, peril) 
 */
function setDeductibleObj(dedLevel){
	try{
		var objDeductible = new Object();
		
		objDeductible.parId				= (objUWGlobal.packParId != null ? objCurrPackPar.parId :  $F("globalParId"));
		objDeductible.dedLineCd			= (objUWGlobal.packParId != null ? objCurrPackPar.lineCd : $F("globalLineCd"));
		objDeductible.dedSublineCd		= (objUWGlobal.packParId != null ? objCurrPackPar.sublineCd : 
			($F("globalSublineCd")=="" && dedLevel == 1 ? $F("sublineCd") : $F("globalSublineCd")));
		objDeductible.userId			= userId;	//"${PARAMETERS['userId']}";
		objDeductible.itemNo 			= (1 < dedLevel ? $F("itemNo") : 0);	//itemNo;
		objDeductible.perilCd 			= (3 == dedLevel ? $F("perilCd") : 0);	//perilCd;
		//objDeductible.dedDeductibleCd 	= $F("txtDeductibleCd"+dedLevel);	//deductibleCd;
		//objDeductible.deductibleTitle 	= $F("txtDeductibleDesc"+dedLevel);	//deductibleTitle;
		objDeductible.dedDeductibleCd 	= escapeHTML2($F("txtDeductibleCd"+dedLevel));	//deductibleCd; // replaced by: Mark C  03.10.2015 SR4302
		objDeductible.deductibleTitle 	= escapeHTML2($F("txtDeductibleDesc"+dedLevel));	//deductibleTitle; // replaced by: Mark C  03.10.2015 SR4302
		objDeductible.deductibleAmount 	= $F("inputDeductibleAmount"+dedLevel) == "" ? null : $F("inputDeductibleAmount"+dedLevel); //deductibleAmt;
		objDeductible.deductibleRate 	= $F("deductibleRate"+dedLevel) == "" ? null : $F("deductibleRate"+dedLevel); //deductibleRate;
		objDeductible.deductibleText	= escapeHTML2($F("deductibleText"+dedLevel));	//deductibleText;
		objDeductible.aggregateSw		= $("aggregateSw"+dedLevel).checked ? "Y" : "N";	//aggregateSw;
		objDeductible.ceilingSw		 	= (1 == dedLevel ? ($("ceilingSw"+dedLevel).checked ? "Y" : "N") : "N");	//ceilingSw;
		objDeductible.deductibleType 	= dedLevel == 3 || dedLevel == 2 ? $("txtDeductibleCd"+dedLevel).getAttribute("deductibleType"):$F("txtDeductibleCd"+dedLevel);	//deductibleType;  //added by steven for the dedtype
		objDeductible.minimumAmount  	= (objDeductible.deductibleType == "L" || objDeductible.deductibleType == "I" ) ? $("txtDeductibleCd"+dedLevel).getAttribute("minAmt"): "";	//minimumAmount;
		objDeductible.maximumAmount	 	= (objDeductible.deductibleType == "L" || objDeductible.deductibleType == "I" ) ? $("txtDeductibleCd"+dedLevel).getAttribute("maxAmt"): "";	//maximumAmount;
		objDeductible.rangeSw		 	= (objDeductible.deductibleType == "L" || objDeductible.deductibleType == "I" ) ? $("txtDeductibleCd"+dedLevel).getAttribute("rangeSw"): "";	//rangeSw;
		
		return objDeductible;
	}catch(e){
		showErrorMessage("setDeductibleObj", e);
	}	
}