function setACItemObject(newObj) {
	try {
		var gipiWAHObject = new Object();
		
		gipiWAHObject.dateOfBirth 			= nvl($F("pDateOfBirth"), null);
		gipiWAHObject.age					= nvl($F("pAge"), "");
		gipiWAHObject.civilStatus   		= nvl($F("pCivilStatus"), "");
		gipiWAHObject.positionCd			= $F("positionCd");
		gipiWAHObject.monthlySalary 		= $F("monthlySalary") == "" ? null : ($F("monthlySalary")).replace(/,/g, "");
		//gipiWAHObject.salaryGrade 			= $F("salaryGrade");
		gipiWAHObject.salaryGrade 			= escapeHTML2($F("salaryGrade")); //replaced by: Mark C. 04132015 SR4302
		gipiWAHObject.noOfPersons 			= $F("noOfPerson") == "" ? null : $F("noOfPerson");
		gipiWAHObject.destination 			= escapeHTML2($F("destination"));
		gipiWAHObject.height 				= nvl(escapeHTML2($F("pHeight")), "");
		//gipiWAHObject.weight 				= nvl($F("pWeight"), "");
		gipiWAHObject.weight 				= nvl(escapeHTML2($F("pWeight")), ""); //replaced by: Mark C. 04132015 SR4302
		gipiWAHObject.sex 					= nvl($F("pSex"), "");
		gipiWAHObject.groupPrintSw 			= nvl($F("groupPrintSw"), "");
		gipiWAHObject.acClassCd 			= nvl($F("acClassCd"), "");
		gipiWAHObject.levelCd 				= nvl($F("levelCd"), "");
		gipiWAHObject.parentLevelCd 		= nvl($F("parentLevelCd"), "");
		gipiWAHObject.changeNOP			    = nvl($F("deleteGroupedItemsInItem"), "N");
		
		newObj.gipiWAccidentItem = gipiWAHObject;
		
		return newObj;
	} catch(e) {
		showErrorMessage("setACItemObject", e);		
	}
}