function convertStringForDate(dateString){		
	var dateString = $w(dateString.replace(/-/g, " "));		
	return new Date(dateString[2], dateString[0] - 1, dateString[1]);
}