function confirmChangesInMaintainedRatesAmts(){
	if ("N" == $F("changedPlanChTag")){
		if (("Y" == $F("varPlanAmtCh")) && ("Y" == $F("vOra2010Sw")) && ("N" == $F("varPlanSwUntag"))){
			showConfirmBox("Modify Plan", 
					"Are you sure you want to change the maintained TSI?", 
					"Yes", 
					"No", 
				function(){ 
					$("planChTag").value = "Y"; 
					$("changedPlanChTag").value = "Y";
				}, 
				function(){
					return false;
				}
			);
		}
	}
}