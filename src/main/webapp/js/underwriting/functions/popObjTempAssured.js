function popObjTempAssured(){
	try{		
		objTempAssured.assdName =$F("assuredNameMaint");
		objTempAssured.lastName = $F("lastName");
		objTempAssured.firstName = $F("firstName");
		objTempAssured.middleInitial = $F("middleInitial");
		objTempAssured.assdNo = $F("assuredNo");
		objTempAssured.mailAddress1 = $F("mailAddress1");
		objTempAssured.mailAddress2 = $F("mailAddress2");
		objTempAssured.mailAddress3 = $F("mailAddress3");
		
	}catch(e){
		showErrorMessage("popObjTempAssured",e);
	}
}