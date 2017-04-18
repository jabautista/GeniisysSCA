function confirmNegation(obj){
	var msg = "Are you sure you want to negate this distribution?";
	if(nvl(obj.exists, "N") == "Y"){
		if(nvl(obj.catastrophicCd, "") == ""){
			msg = "Claim is already distributed to excess of loss treaty, "+
             	  "Negating this record would require redistribution of other loss expense record. "+
             	  "Do you want to continue?";
		}else{
			msg = "Catastrophic event to which this record is included has been distributed for Excess of Loss. " +
			      "Negating this record would require redistribution of all record under this event. " +
			      "Do you want to continue?";
		}
	}
	
	showConfirmBox("Confirmation", msg, "Yes", "No", 
			function(){
				negateLossExpHistory(nvl(obj.exists, "N"), nvl(obj.currXOL, "N"));
			}, function(){});
	
}