/**
 * Validates the time in tablegrid filter
 * @author kenneth 
 * @param element - input field id (HH:MM:SS AM/PM format.)
 * @return boolean
 */
function IsValidFilterTime(element) {
	var timeStr = element;
	var timePat = /^(\d{2}):(\d{2})(:(\d{2}))?(\s?(AM|am|PM|pm))?$/;
	var matchArray = timeStr.match(timePat);
	if (matchArray == null) {
		showMessageBox("Time must be entered in a format like HH:MI:SS AM.", "I");
		return false;
	}
	var hour = matchArray[1];
	var minute = matchArray[2];
	var second = matchArray[4];
	var ampm = matchArray[6];

	if (hour < 0 || hour > 12) {
		showMessageBox("Hour must be between 1 and 12.", "I");
		return false;
	}
	if (minute<0 || minute > 59) {
		showMessageBox("Minute must be between 0 and 59.", "I");
		return false;
	}
	if (hour <= 12 && ampm == null) {
		showMessageBox("You must specify AM or PM.", "I");
		return false;
	}
	if (second != null && (second < 0 || second > 59)) {
		showMessageBox("Second must be between 0 and 59.", "I");
		return false;	
	}
	if (second == null) {
		showMessageBox("Time must be entered in a format like HH:MI:SS AM.", "I");
		return false; // bonok :: 8.25.2015 :: UCPB SR 20210
	}
	return true;
}