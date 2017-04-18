//NOK 04.27.2011 for accident additional info
function setQuoteAHAdditional(itemObj){
	try{
		var newObj = {};
		var objAH = objMKTG.selAdditionalInfoGIIMM002Obj;
		newObj.quoteId			= nvl(itemObj.quoteId,'');
		newObj.itemNo			= nvl(itemObj.itemNo,'');
		newObj.noOfPerson 		= escapeHTML2($("txtNoOfPerson").value);
		newObj.positionCd 		= escapeHTML2($("position").value);
		newObj.monthlySalary 	= escapeHTML2(unformatNumber($("txtSalary").value));
		newObj.salaryGrade 		= escapeHTML2($("txtSalaryGrade").value);
		newObj.destination 		= escapeHTML2($("txtDestination").value);
		newObj.acClassCd		= nvl(objAH,null) == null ? "" :nvl(objAH.acClassCd, "");
		newObj.age 				= escapeHTML2($("txtAge").value);
		newObj.civilStatus 		= escapeHTML2($("civilStatus").value);
		newObj.dateOfBirth 		= escapeHTML2($("txtDateOfBirth").value);
		newObj.groupPrintSw		= nvl(objAH,null) == null ? "" :nvl(objAH.groupPrintSw, "");
		newObj.height 			= escapeHTML2($("height").value);
		newObj.levelCd			= nvl(objAH,null) == null ? "" :nvl(objAH.levelCd, "");
		newObj.parentLevelCd	= nvl(objAH,null) == null ? "" :nvl(objAH.parentLevelCd, "");
		newObj.sex 				= escapeHTML2($("sex").value);
		newObj.weight 			= escapeHTML2($("weight").value);
		
		return newObj; 
	}catch (e) {
		showErrorMessage("setQuoteAHAdditional Error", e);
	}
}