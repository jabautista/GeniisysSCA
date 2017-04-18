// Created by andrew 06.22.2010
// Checks the duration dates if it falls in a leaf year or not. 
// Returns 366 if a date is in a leaf year and 365 if not.
// Parameters : date1 - start date
//				date2 - end date
function checkDuration(date1, date2){
	try {
		var tempDate1 = Date.parse(dateFormat(date1, "mmmm d, yyyy"));
		var tempDate2 = Date.parse(dateFormat(date2, "mmmm d, yyyy"));
		
		if (getNoOfDaysInYear(tempDate1.getFullYear()) == 366
			&& tempDate1 <= Date.parse("February 29, " + tempDate1.getFullYear())
			&& tempDate2 >= Date.parse("February 29, " + tempDate1.getFullYear())
			){
			return 366;	
		} else if (getNoOfDaysInYear(tempDate2.getFullYear()) == 366
					&& tempDate1 <= Date.parse("February 29, " + tempDate2.getFullYear())
					&& tempDate2 >= Date.parse("February 29, " + tempDate2.getFullYear())) {
			return 366;
		} else {
			return 365;
		}
	} catch (e){
		showErrorMessage("checkDuration", e);
		//showMessageBox("checkDuration : " + e.message, imgMessage.WARNING);
	}		
}