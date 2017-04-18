//created by: Jerome Orio
//to get the numbers of days in a year
//parameter: year you want to get
function getNoOfDaysInYear(year){
	var startDate = "01-01-"+year;
	var lastDate = "12-31-"+year;
	var oneDay = 1000*60*60*24;
	var noOfDaysInAYear = "";

	var iDateArray = startDate.split("-");
	var iDate = new Date();
	var date = parseInt(iDateArray[1], 10);
	var month = parseInt(iDateArray[0], 10);
	var year = parseInt(iDateArray[2], 10);
	iDate.setFullYear(year, month-1, date);

	var eDateArray = lastDate.split("-");
	var eDate = new Date();
	var edate = parseInt(eDateArray[1], 10);
	var emonth = parseInt(eDateArray[0], 10);
	var eyear = parseInt(eDateArray[2], 10);
	eDate.setFullYear(eyear, emonth-1, edate);
	
	noOfDaysInAYear = Math.floor((parseInt(Math.floor(eDate.getTime() - iDate.getTime()))/oneDay)+1);
	return noOfDaysInAYear;
}