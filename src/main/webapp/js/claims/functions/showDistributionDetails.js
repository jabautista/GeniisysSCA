function showDistributionDetails(giclClmLossExpense){
	if(nvl(giclClmLossExpense.distSw, "N") == "Y" && nvl(giclClmLossExpense.cancelSw, "N") == "N"){
		$("distDetailsDiv").show();
		$("distDetailsMainDiv").show();
		$("distDtlGro").innerHTML = "Hide";
	}else{
		$("distDetailsDiv").hide();
		$("distDetailsMainDiv").hide();
		$("distDtlGro").innerHTML = "Show";
	}
}