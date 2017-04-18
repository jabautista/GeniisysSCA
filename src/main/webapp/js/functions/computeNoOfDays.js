//created by: Jerome Orio
//to get the numbers of days in a year between two dates
//parameter: startDate start of Date
//parameter: endDate end of Date
//parameter: compSwAddtl condition ,if condition is blank ("") = 0 , for PRORATE
function computeNoOfDays(startDate,endDate,compSwAddtl)	{
	var noOfDays = "";
	if (startDate == "" || endDate == "") {
		return noOfDays;
	} else {
		var addtl = 0;
		if ("Y" == compSwAddtl) {
			addtl = 1;
		} else if ("M" == compSwAddtl) {
			addtl = -1;
		}
		var iDateArray = startDate.split("-");
		var iDate = new Date();
		var date = parseInt(iDateArray[1], 10);
		var month = parseInt(iDateArray[0], 10);
		var year = parseInt(iDateArray[2], 10);
		iDate.setFullYear(year, month-1, date);

		var eDateArray = endDate.split("-");
		var eDate = new Date();
		var edate = parseInt(eDateArray[1], 10);
		var emonth = parseInt(eDateArray[0], 10);
		var eyear = parseInt(eDateArray[2], 10);
		eDate.setFullYear(eyear, emonth-1, edate);

		var oneDay = 1000*60*60*24;
		noOfDays = Math.floor((parseInt(Math.floor(eDate.getTime() - iDate.getTime()))/oneDay)) + addtl;
	}
	return (isNaN(noOfDays) ? "" : noOfDays);
}