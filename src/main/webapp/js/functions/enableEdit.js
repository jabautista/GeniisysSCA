/**
 * Description: Enables the edit icon
 * Date Created : 12.18.2013
 * @author Ildefonso Ellarina Jr
 * */
function enableEdit(imgId){
	try {		
		if($(imgId).next("img",0) != undefined){
			$(imgId).show();
			$(imgId).next("img",0).remove();
		}
	} catch(e){
		showErrorMessage("enableEdit", e);
	}	
}	