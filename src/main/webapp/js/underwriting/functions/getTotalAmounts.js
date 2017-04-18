function getTotalAmounts(){
	var totalTsi = parseFloat(0);
	var totalPrem = parseFloat(0);
	$$("div#itemPerilMotherDiv"+$F("itemNo")+" div[name='row2']").each(function(r){
		var perilType = r.down("input", 8).value;
		var tsiAmt = parseFloat(r.down("input", 5).value.replace(/,/g, ""));
		var premAmt = parseFloat(r.down("input", 6).value.replace(/,/g, ""));
		if (perilType == "B"){
			totalTsi = totalTsi + tsiAmt;
		} 
		totalPrem = totalPrem + premAmt;
	});
	$("perilTotalTsiAmt").value = formatCurrency(totalTsi);
	$("perilTotalPremAmt").value = formatCurrency(totalPrem);
	confirmChangesInMaintainedRatesAmts();
}