/**
 * @author jorio - 20110427
 */
function supplyQuoteAHAdditional(obj){
	try{
		objMKTG.selAdditionalInfoGIIMM002Obj  = obj==null?null:obj;
		$("txtNoOfPerson").value 	= unescapeHTML2(nvl(obj==null?null:obj.noOfPerson,''));
		$("position").value 		= unescapeHTML2(nvl(obj==null?"":obj.positionCd,''));
		$("txtDestination").value 	= unescapeHTML2(nvl(obj==null?null:obj.destination,''));
		$("txtSalary").value 		= unescapeHTML2(nvl(obj==null?null:obj.monthlySalary,''));
		$("txtSalaryGrade").value 	= unescapeHTML2(nvl(obj==null?null:obj.salaryGrade,''));
		$("txtDateOfBirth").value 	= unescapeHTML2(nvl(obj==null?null:(nvl(obj.dateOfBirth,"") == "" ? "" :dateFormat(obj.dateOfBirth, "mm-dd-yyyy")),''));
		$("txtAge").value 			= unescapeHTML2(nvl(obj==null?null:obj.age,''));
		$("civilStatus").value 		= unescapeHTML2(nvl(obj==null?"":obj.civilStatus,''));
		$("sex").value 				= unescapeHTML2(nvl(obj==null?"":obj.sex,''));
		$("height").value 			= unescapeHTML2(nvl(obj==null?null:obj.height,''));
		$("weight").value 			= unescapeHTML2(nvl(obj==null?null:obj.weight,''));
	}catch(e){
		showErrorMessage("supplyQuoteAHAdditional", e);
	}
}