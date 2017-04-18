//getQuoteVesselListing
//get currency rate
function getRates() {
	var index = $("currency").selectedIndex;
	var currRate = $("currFloat").options[index].value;
	$("rate").value = formatToNineDecimal(currRate);
}