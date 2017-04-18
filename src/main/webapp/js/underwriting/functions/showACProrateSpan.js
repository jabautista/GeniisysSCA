function showACProrateSpan() {
	if ($F("fromDate") == "" || $F("toDate") == ""){
		$("accidentProrateFlag").disable();
		$("accidentShortRatePercent").value = "";
		$("accidentNoOfDays").value = "";
		$("accidentShortRatePercent").disable();
		$("accidentNoOfDays").disable();
		$("accidentCompSw").disable();
		$("accidentProrateFlag").removeClassName("required");
		$("accidentShortRatePercent").removeClassName("required");
		$("accidentNoOfDays").removeClassName("required");
		$("accidentCompSw").removeClassName("required");
	}else{
		if(objGIPIWItmperlGrouped != null && (objGIPIWItmperlGrouped.filter(function(o){ return nvl(o.recordStatus, 0) != -1 && o.itemNo == $F("itemNo"); }).length < 1)){
			$("accidentProrateFlag").enable();
		}
		
		$("accidentShortRatePercent").enable();
		$("accidentNoOfDays").enable();
		$("accidentCompSw").enable();
		$("accidentProrateFlag").addClassName("required");
		$("accidentShortRatePercent").addClassName("required");
		$("accidentNoOfDays").addClassName("required");
		$("accidentCompSw").addClassName("required");
		if ($F("accidentProrateFlag") == "1")	{
			$("shortRateSelectedAccident").hide();
			$("prorateSelectedAccident").show();
			
			switch($F("accidentCompSw")){
				case "Y"	: $("accidentNoOfDays").value  = parseInt($F("accidentDaysOfTravel")) + 1; break;
				case "M"	: $("accidentNoOfDays").value  = parseInt($F("accidentDaysOfTravel")) - 1; break;
				default		: $("accidentNoOfDays").value  = $F("accidentDaysOfTravel"); break;
			}			
		} else if ($F("accidentProrateFlag") == "3") {			
			$("prorateSelectedAccident").hide();
			$("shortRateSelectedAccident").show();
			$("accidentNoOfDays").value = "";
		} else {			
			$("shortRateSelectedAccident").hide();
			$("prorateSelectedAccident").hide();
			$("accidentNoOfDays").value = "";
			$("accidentShortRatePercent").value = "";
			$("accidentCompSw").selectedIndex = 2;
		}
	}
	
	objFormVariables.varVOldNoOfDays = $F("accidentNoOfDays");
}