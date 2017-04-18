/** 
 * A version of checkAllRequiredFields, which will determine if there are required field in a given div element
 * @author andrew robes
 * @date 10.25.2011
 * @params divId - id of div containing the fields to be checked
 * @returns true - if all required fields has a value else false
 * 
 */
function checkAllRequiredFieldsInDiv(divId) {
	try{
		var isComplete = true;
		$$("div#"+divId+" input[type='text'].required, div#"+divId+" textarea.required, div#"+divId+" select.required, div#"+divId+" input[type='file'].required").each(function (o) {
			if (o.value.blank()){
				isComplete = false;
				customShowMessageBox(objCommonMessage.REQUIRED, "I", o.id);
				throw $break;
			}
		});
		return isComplete;
	}catch(e){
		showErrorMessage("checkAllRequiredFieldsInDiv",e);
	}
	
}