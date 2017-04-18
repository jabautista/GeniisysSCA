function computeEvalDeductibleAmount(){
	 if($("txtEvalDedUnits").value == ""){
		 $("txtEvalDedUnits").value = 1;
	 }
	 
	 var dedRate = nvl($("txtEvalDedRate").value, 0);
	 var dedBaseAmt = nvl(unformatCurrencyValue($("txtEvalDedBaseAmt").value), 0);
	 var noOfUnit = $("txtEvalDedUnits").value;
	 var dedAmt = 0;
	 
	 if(parseFloat(dedRate) != 0){
		 dedAmt = parseFloat(dedBaseAmt)*((parseFloat(dedRate)/100)*noOfUnit);
	 }else{
		 dedAmt = parseFloat(dedBaseAmt)*parseFloat(noOfUnit);
	 }
	 
	 if(parseFloat(dedAmt) < 0){
		 dedAmt = parseFloat(dedAmt)*-1;
	 }
	 
	 $("txtEvalDedAmt").value = formatCurrency(dedAmt);
}