function generateAssuredName() {
	if($F("nameOrder")=="1") {
		/* $("assuredNameMaint").value = ($F("lastName") == "" ? "" : (($F("firstName") == "" && $F("middleInitial") == "") ? $F("lastName") : $F("lastName") + ", ")) +
		  ($F("firstName") == "" ? "" :$F("firstName") + " ") + ($F("middleInitial") == "" ? "" :$F("middleInitial") + ". ");*/
		$("assuredNameMaint").value = ($F("lastName") == "" ? "" : (($F("firstName") == "" && $F("middleInitial") == "" && $F("suffix") == "") ? $F("lastName").trim() : $F("lastName").trim() + ",")) +
		  ($F("firstName") == "" ? "" : (" "+$F("firstName").trim() + "")) +
		  ($F("suffix") == "" ? "" : " "+$F("suffix").trim()) +
		  ($F("middleInitial") == "" ? "" :" "+$F("middleInitial").trim() + ".");
	} else {
		//$("assuredNameMaint").value = ($F("firstName") == "" ? "" :$F("firstName") + " ")+ ($F("middleInitial") == "" ? "" :$F("middleInitial") + ". ") + $F("lastName");
		$("assuredNameMaint").value = ($F("firstName") == "" ? "" :$F("firstName").trim() + " ")+ ($F("middleInitial") == "" ? "" :$F("middleInitial").trim() + ". ") + 
				  ($F("lastName") == "" ? "" :($F("suffix") == "" ? $F("lastName").trim() : $F("lastName").trim()))+
				  ($F("suffix") == "" ? "" : " "+$F("suffix").trim());
	} 
} 