function checkRedistribute(giclClmLossExp, enableRadio){
	if(nvl(giclClmLossExp.withLossExpDsNotNegated, "N") == "Y"){
		enableRadio = true;
		enableButton("btnDistribute");
		enableButton("btnDistDate");
		$("btnDistribute").value = "Redistribute";
	}else{
		$("btnDistribute").value = "Distribute";
	}
	
	if(enableRadio){
		$("radioUW").enable();
		$("radioReserve").enable();
	}else{
		$("radioUW").disable();
		$("radioReserve").disable();
	}
}