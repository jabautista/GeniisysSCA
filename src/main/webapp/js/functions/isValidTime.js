/**
 * Validates the manual TIME input
 * @author niknok 
 * @param element - input field id (HH:MM:SS AM/PM format.)
 * @param defaultAmPm - default AM/PM 
 * @param upperCaseAmPm - true if upperCase
 * @param displaySec - will display seconds, default is TRUE
 * @return boolean
 */
function isValidTime(element, defaultAmPm, upperCaseAmPm, displaySec) {
	// Checks if time is in HH:MM:SS AM/PM format.
	// The seconds and AM/PM are optional.
	var timeStr = $F(element).strip();
	if (nvl(timeStr,"")=="") return true;
	var timePat = /^(\d{1,2}):(\d{2})(:(\d{2}))?(\s?(AM|am|PM|pm|Am|aM|Pm|pM))?$/;

	var matchArray = timeStr.match(timePat);
	if (matchArray == null) {
		//customShowMessageBox("Time is not in a valid format.", imgMessage.ERROR, element); //belle 05.22.2012 
		customShowMessageBox("Time must be entered in a format like HH:MI AM.", imgMessage.ERROR, element);
		$(element).value = "";
		return false;
	}
	var hour = matchArray[1];
	var minute = matchArray[2];
	var second = matchArray[4];
	var ampm = matchArray[6];
	
	//will not display Seconds if parameter displaySec is FALSE - default is TRUE
	if (!displaySec){
		$(element).value = nvl(ampm,null) == null ? (hour+":"+minute) :(hour+":"+minute+" "+ampm);
	}
	
	//set default AM/PM
	ampm = nvl(matchArray[6], defaultAmPm);
	if (nvl(matchArray[6],null) == null){
		$(element).value = nvl(ampm,null) == null ? $F(element) :$F(element).strip()+" "+ampm;
	} 
	
	//convert to Upper/Lower case
	var upperCaseAmPm = nvl(upperCaseAmPm,true);
	if (upperCaseAmPm){
		$(element).value = $F(element).toUpperCase();
	}else{
		$(element).value = $F(element).toLowerCase();
	}
		
	if (second == ""){ 
		second = null; 
	}
	if (ampm == "") { 
		ampm = null; 
	}

	if (hour < 0 || hour > 12) {
		customShowMessageBox("Hour must be between 1 and 12.", imgMessage.ERROR, element);
		$(element).value = "";
		return false;
	}
	if (minute<0 || minute > 59) {
		//if (!displaySec) return; -- marco - 07.05.2012 - to enter validation even if displaySec is set to false
		customShowMessageBox("Minute must be between 0 and 59.", imgMessage.ERROR, element);
		$(element).value = "";
		return false;
	}
	if (hour <= 12 && ampm == null) {
		customShowMessageBox("You must specify AM or PM.", imgMessage.ERROR, element);
		$(element).value = "";
		return false;
	}
	if (hour > 12 && ampm != null) {
		customShowMessageBox("You can't specify AM or PM for military time.", imgMessage.ERROR, element);
		$(element).value = "";
		return false;
	}

	if (second != null && (second < 0 || second > 59)) {
		if (!displaySec) return;
		customShowMessageBox("Second must be between 0 and 59.", imgMessage.ERROR, element);
		$(element).value = "";
		return false;
	}
	return true;
}