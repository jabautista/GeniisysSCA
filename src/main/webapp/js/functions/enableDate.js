/**
 * Enables the search icon
 * @author andrew robes
 * @date 11.17.2011
 */
function enableDate(imgId){
	try {	
		if($(imgId).next("img",0) != undefined){
			$(imgId).show();
			$(imgId).next("img",0).remove();
		}
	} catch(e){
		showErrorMessage("enableDate", e);
	}	
}