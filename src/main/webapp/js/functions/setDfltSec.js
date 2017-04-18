/**
 * @author niknok 10.26.2011
 * @param dateTime - date with time w/o seconds
 * @returns {String} - date with time and default seconds
 */
function setDfltSec(dateTime){
	if (nvl(dateTime,"") == "") return;
	var timeStr = dateTime.strip();
	var timePat = /^\d{2}-\d{2}-\d{4}\s(\d{1,2}):(\d{2})(:(\d{2}))?(\s?(AM|am|PM|pm|Am|aM|Pm|pM))?$/;
 
	var matchArray = timeStr.match(timePat);
	//var second = matchArray[4]; replaced by: Nica 06.14.2012 to handle error for null matchArray
	var second = nvl(matchArray,null) == null ? null : matchArray[4];
	if (nvl(second,null) == null && nvl(matchArray,null) != null) {	
		dateTime = dateTime.replace(/ AM/g,":00 AM").replace(/ PM/g,":00 PM");
	}	
	return dateTime;
}