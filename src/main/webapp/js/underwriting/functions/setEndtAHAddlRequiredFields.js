/**
 * Sets the required field for endt accident additional information form
 * @author andrew
 * @date 10.05.2011
 */
function setEndtAHAddlRequiredFields(recFlag){	
	try {		
		recFlag == "A" ? $("noOfPerson").addClassName("required") : $("noOfPerson").removeClassName("required");		
	} catch (e){
		showErrorMessage("setEndtMNAddlRequiredFields", e);
	}
}