/**
 * Enables the field
 * @author Irwin Tabisora
 * @date 01.27.2012
 */
function disableInputField(id){
	try{
		$(id).setAttribute("readonly", "readonly");
	}catch(e){
		showErrorMessage("disableInputField", e);
	}
}