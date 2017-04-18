/*	Created by	: mark jm 10.15.2010
 * 	Description	: just call the function for showing the editor for textarea
 * 	Parameter	: elemName - destination for the text area's value
 * 				: elemLength - maximum characters to be accepted
 */
function showOtherInfo(elemName, elemLength){
	try{		
		showItemEditor(elemName, elemLength);		
	}catch(e){
		showErrorMessage("showOtherInfo", e);
		//showMessageBox("showEditor : " + e.message);
	}
}