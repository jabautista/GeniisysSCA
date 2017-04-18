/**
 * ignoring the hours/mins/secs/millis on date
 * @param date
 * @author nok
 * @return date 
 */
function ignoreDateTime(date){
	date.setHours(0);
	date.setMinutes(0);
	date.setSeconds(0);
	date.setMilliseconds(0);
	return date;
}