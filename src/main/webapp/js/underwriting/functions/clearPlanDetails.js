function clearPlanDetails(){
	$("planSw").value = "N";
	$("planCd").value = "";
 	if (("0" == $F("globalPackParId")) && ("Y" == $F("varPlanSw")) && ("Y" == $F("vOra2010Sw"))){
 		$("varPlanPerilCh").value = "Y";
 		$("varPlanCreateCh").value = "Y";
 	}
 	if (("0" != $F("globalPackParId")) && ("Y" == $F("varPackPlanSw")) && ("Y" == $F("vOra2010Sw"))){
 		$("varPlanPerilCh").value = "Y";
 		$("varPlanCreateCh").value = "Y";
 	}
}