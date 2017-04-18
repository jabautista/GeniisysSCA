/**
 * Enables the field
 * @author Irwin Tabisora
 * @date 01.27.2012
 */
function enableInputField(id){
	try{
		$(id).removeAttribute("readonly");
	}catch(e){
		showErrorMessage("enableInputField", e);
	}
}