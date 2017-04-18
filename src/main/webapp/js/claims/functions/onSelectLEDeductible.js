function onSelectLEDeductible(ded){
	try{
		var dedType = unescapeHTML2(ded.deductibleType);
		var aggSw = unescapeHTML2(ded.aggregateSw);
		var ceilingSw = unescapeHTML2(ded.ceilingSw);
		var dedSublineCd = unescapeHTML2(ded.dedSublineCd);
		var dedRate = nvl(ded.dedRate,0);
		var dedLossExpCd = $("txtDedLossExpCd").getAttribute("dedLossExpCd");
		
		clearLEDeductibleForm();
		if(nvl(dedSublineCd, "") != ""){
			$("txtDeductibleAmt").readOnly = true;
			if(dedRate == 0){
				$("txtDedBaseAmt").readOnly = true;
			}
			$("txtDedRate").readOnly = true;
			$("txtDedUnits").readOnly = true;  //added by steven 12/12/2012
			
		}else{
			$("txtDedBaseAmt").readOnly = false;
			$("txtDedRate").readOnly = false;
			$("txtDeductibleAmt").readOnly = false;
			$("txtDedUnits").readOnly = false; //added by steven 12/12/2012
		}
		
//		$("txtDedBaseAmt").readOnly = false; remove by steven 12/12/2012 base on SR 0011437 Deductible Type, Deductible Text, Base Amount, Unit(s) and Deductible Rate should not be updateable.
//		$("txtDedRate").readOnly = false; 
		
		if(nvl(dedType, "") != ""){
			if(dedType == "F" && nvl(ceilingSw, "N") != "Y" && nvl(aggSw, "N") != "Y"){ // Fixed Amount
				$("txtDedBaseAmt").readOnly = true;
				$("txtDedRate").readOnly = true;
			}else if(dedType == "L"){ // % of Loss Amount
				$("txtDedBaseAmt").readOnly = true;
				$("txtDedRate").readOnly = true;
			}else if(dedType == "T"){ // % of TSI Amount
				$("txtDedBaseAmt").readOnly = true;
				$("txtDedRate").readOnly = true;
				//$("txtDedBaseAmt").removeClassName("required"); // bonok :: 10.18.2012
				dedBaseAmtRequired = "N"; // bonok :: 10.18.2012
			}else if(dedType == "I"){ // % of the insured value at the time of loss
				$("txtDedBaseAmt").readOnly = true;
				$("txtDedRate").readOnly = true;
			}
		}
		
		$("txtLossExpCd").value = unescapeHTML2(ded.dedTitle);
		$("txtLossExpCd").setAttribute("lossExpCd", unescapeHTML2(ded.dedCd));
		$("txtDeductibleText").value = unescapeHTML2(ded.dedText);
		$("txtDeductibleType").value = unescapeHTML2(ded.dedType);
		$("txtDedUnits").value = 1;
		$("hidDedSublineCd").value = unescapeHTML2(ded.dedSublineCd);
		$("hidDedType").value = unescapeHTML2(ded.deductibleType);
		$("hidDedCompSw").value = unescapeHTML2(ded.compSw);
		$("hidDedAggregateSw").value = unescapeHTML2(ded.aggregateSw);
		$("hidDedCeilingSw").value = unescapeHTML2(ded.ceilingSw);
		$("hidDedMinAmt").value = nvl(ded.minAmt, "");
		$("hidDedMaxAmt").value = nvl(ded.maxAmt, "");
		$("hidDedRangeSw").value = unescapeHTML2(ded.rangeSw);
		$("txtDeductibleAmt").value = formatCurrency(ded.dedAmount);
		$("txtDedRate").value = formatToNineDecimal(ded.dedRate);
		$("txtDedBaseAmt").value = 0;
		validateSelectedLEDeductible();
				
	}catch(e){
		showErrorMessage("onSelectLossExpDeductibles", e);	
	}
}