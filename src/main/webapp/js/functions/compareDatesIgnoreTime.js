/**
 * Compares date1 with date2 ignoring the hours/mins/secs/millis
 * @param date1
 * @param date2
 * @author rencela
 * @return -1 when date1 is greater
 * @return 0 for equal
 * @return 1 when date2 is greater 
 */
function compareDatesIgnoreTime(date1, date2){
	date1.setHours(0);
	date1.setMinutes(0);
	date1.setSeconds(0);
	date1.setMilliseconds(0);
	date2.setHours(0);
	date2.setMinutes(0);
	date2.setSeconds(0);
	date2.setMilliseconds(0);
	if(date1>date2){
		return -1;
	} else if(date1<date2){
		return 1;
	} else {
		return 0;
	}
}