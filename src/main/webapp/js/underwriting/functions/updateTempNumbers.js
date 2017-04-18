//Update temp item for item info and endt item info
function updateTempNumbers(){		
	var temp = $F("tempItemNumbers");
	
	if($F("tempItemNumbers") != null || $F("itemNumbers") != ""){
		$("tempItemNumbers").value = temp + $F("itemNo") + " ";
	}

	if($F("globalLineCd") == "MC"){
		temp = $F("motorNumbers").trim();
		if($F("motorNumbers") != ""){
			$("motorNumbers").value = temp + "\n" + $F("motorNo");
		}

		temp = $F("serialNumbers").trim();
		if($F("serialNumbers") != ""){
			$("serialNumbers").value = temp + "\n" + $F("serialNo");
		}

		temp = $F("plateNumbers").trim();
		if($F("plateNumbers") != ""){
			$("plateNumbers").value = temp + "\n" + $F("plateNo");
		}
	} else if($F("globalLineCd") == "FI"){
		temp = $F("riskNumbers");
		if($F("riskNumbers") != null){
			$("riskNumbers").value = temp + $F("riskNo") + " ";
		}

		temp = $F("riskItemNumbers");
		if($F("riskItemNumbers") != null){
			$("riskItemNumbers").value = temp + $F("riskItemNo") + " ";
		}
	}
	
}