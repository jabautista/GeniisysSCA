function enableDisableDeductibleForm(enableSw){
	if(enableSw == "enable"){
		$("txtDedUnits").readOnly = false; 		 
		$("txtDedRate").readOnly = false; 		 
		$("txtDedBaseAmt").readOnly = false;	 
		$("txtDeductibleAmt").readOnly = false;
		//$("hrefLossExpCd").show();
		$("hrefDedLossExpCd").show();
		
		var dedType = $("hidDedType").value;
		var aggSw = $("hidDedAggregateSw").value;
		var ceilingSw = $("hidDedCeilingSw").value;
		var dedSublineCd = $("hidDedSublineCd").value;
		var dedRate = nvl($("txtDedRate").value,0);
		var dedLossExpCd = $("txtDedLossExpCd").getAttribute("dedLossExpCd");
		
		if(nvl(dedSublineCd, "") != ""){
			$("txtDeductibleAmt").readOnly = true;
			if(parseFloat(dedRate) == 0){
				$("txtDedBaseAmt").readOnly = true;
			}
			$("txtDedRate").readOnly = true;
			
		}else{
			$("txtDedBaseAmt").readOnly = false;
			$("txtDedRate").readOnly = false;
			$("txtDeductibleAmt").readOnly = false;
		}
		
		$("txtDedBaseAmt").readOnly = false;
		$("txtDedRate").readOnly = false;
		
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
			}else if(dedType == "I"){ // % of the insured value at the time of loss
				$("txtDedBaseAmt").readOnly = true;
				$("txtDedRate").readOnly = true;
			}
		}
	}else{
		$("txtDedUnits").readOnly = true; 		 
		$("txtDedRate").readOnly = true; 		 
		$("txtDedBaseAmt").readOnly = true;	 
		$("txtDeductibleAmt").readOnly = true;
		$("hrefLossExpCd").hide();
		$("hrefDedLossExpCd").hide();
		disableButton("btnComputeDepreciation");
		disableButton("btnClearDeductibles");
		disableButton("btnSaveDeductibles");
		disableButton("btnAddLossExpDeductible");
		disableButton("btnDeleteLossExpDeductible");
	}
	
}