/**
 * @author niknok 10.26.2011
 * @param twelveHrFormat - true or false
 * @returns {String} - date with time
 */
function getCurrentDateTime(twelveHrFormat){
	try{
		var currentTime = new Date();
		var date = "";
		var month = currentTime.getMonth() + 1;
		var day = currentTime.getDate();
		var year = currentTime.getFullYear();
		month = formatNumberDigits(month,2);
		day = formatNumberDigits(day,2);
		date = month+"-"+day+"-"+year;
		
		var time = "";
		var hours = currentTime.getHours();
		var minutes = currentTime.getMinutes();
		var seconds = currentTime.getSeconds();
		var amPm = (hours > 11 ? " PM" :" AM");
		hours = (twelveHrFormat == true && hours > 12) ? (Number(hours)-12) : hours;
		hours = (hours < 10 ? ("0" + hours) :hours);
		minutes = (minutes < 10 ? ("0" + minutes) :minutes);
		seconds = (seconds < 10 ? ("0" + seconds) :seconds);
		time = hours+":"+minutes+":"+seconds+amPm;

		return date+" "+time;
	}catch(e){
		showErrorMessage("getCurrentDateTime", e);
	}
}