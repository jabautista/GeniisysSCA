/**
 * Disables the date icon
 * @param imgId - id of date image element
 */
function disableDate(imgId){
	try {
		if($(imgId).next("img",0) == undefined){
			var alt = new Element("img");
			alt.src = contextPath + "/images/misc/disabledCalendarIcon.gif";
			$(imgId).hide();
			$(imgId).insert({after : alt});
		}		
	} catch(e){
		showErrorMessage("disableDate", e);
	}	
}