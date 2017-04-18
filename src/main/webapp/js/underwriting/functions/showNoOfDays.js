function showNoOfDays(){
	if (($F("perilNoOfDays") == "") && ("none" != document.getElementById("accPerilDetailsDiv").style.display)){
		var fromDate = $F("fromDate") == "" ? $F("globalEffDate") : $F("fromDate");
		var toDate = $F("toDate") == "" ? $F("globalExpiryDate") : $F("toDate");
		$("perilNoOfDays").value = computeNoOfDays(fromDate, toDate, "");
	}
}