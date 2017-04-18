function subtractDatesAddTwelve() {
	var iDateArray = (objGIPIQuote.inceptDate != null ? objGIPIQuote.inceptDate.split("-") : $F("globalInceptDate").split("-"));//$F("globalInceptDate").split("-");
	var iDate 	= new Date();
	var date 	= parseInt(iDateArray[1], 10);
	var month 	= parseInt(iDateArray[0], 10) + 12;
	var year 	= parseInt(iDateArray[2], 10);
	if (month > 12) {
		month -= 12;
		year += 1;
	}
	iDate.setFullYear(year, month-1, date);
	//var eDateArray = $F("globalInceptDate").split("-");
	var eDateArray = (objGIPIQuote.inceptDate != null ? objGIPIQuote.inceptDate.split("-") : $F("globalInceptDate").split("-"));
	var eDate = new Date();
	var edate = parseInt(eDateArray[1], 10);
	var emonth = parseInt(eDateArray[0], 10);
	var eyear = parseInt(eDateArray[2], 10);
	eDate.setFullYear(eyear, emonth-1, edate);
	var oneDay = 1000*60*60*24;
	return parseInt(Math.ceil((iDate.getTime() - eDate.getTime())/oneDay));
}