/**
 * Disables the search icon
 * @author andrew robes
 * @date 11.17.2011
 */
function disableSearch(imgId){
	try {
		if($(imgId).next("img",0) == undefined){
			var alt = new Element("img");
			alt.alt = 'Go';
			alt.src = contextPath + "/images/misc/disabledSearchIcon.png";
			alt.style.cssText = $(imgId).style.cssText; //edited MarkS 5.25.2016 SR-22263 
			$(imgId).hide();
			$(imgId).insert({after : alt});			
		}		
	} catch(e){
		showErrorMessage("disableSearch", e);
	}	
}