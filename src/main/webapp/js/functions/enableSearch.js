/**
 * Enables the search icon
 * @author andrew robes
 * @date 11.17.2011
 */
function enableSearch(imgId){
	try {		
		if($(imgId).next("img",0) != undefined){
			$(imgId).show();
			$(imgId).next("img",0).remove();
		}
	} catch(e){
		showErrorMessage("enableSearch", e);
	}	
}