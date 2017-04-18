// convert string date to date object
// parameter: str
// str: date string to be converted
function makeDate(str) {
	var delimChar = (str.indexOf("/") != -1) ? "/" : "-";
	var strDate = str.split(delimChar);
	//var strDate = str.split("-");
	var iDate = new Date();
	var month = parseInt(strDate[0], 10);
	var date = parseInt(strDate[1], 10);
	var year = parseInt(strDate[2], 10);
	
	// added to handle date discrepancy
	iDate.setHours(0);
	iDate.setMinutes(0);
	iDate.setSeconds(0);
	iDate.setMilliseconds(0);
	iDate.setHours(0);
	iDate.setMinutes(0);
	iDate.setSeconds(0);
	iDate.setMilliseconds(0);
	iDate.setFullYear(year, month-1, date);
	iDate.format('mm-dd-yyyy');
	return iDate;
}