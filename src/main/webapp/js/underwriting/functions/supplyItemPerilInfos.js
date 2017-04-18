function supplyItemPerilInfos(objPeril){
	try{
		var perilCd						= objPeril == null ? "" : objPeril.perilCd;//row.down("input", 3).value;
		var peril						= $("perilCd");
		var index = 0;
		var compRem = null;
		
		for (var j=0; j<peril.length; j++){
			if (peril.options[j].value == perilCd){
				index = j;
			}
		}
		
		$("perilCd").selectedIndex 		= index;
		$("txtPerilCd").value			= objPeril == null ? "" : objPeril.perilCd;
		$("perilRate").value 		    = objPeril == null ? "" : (objPeril.premRt == null ? "" : formatToNineDecimal(objPeril.premRt));
		$("perilTsiAmt").value			= objPeril == null ? "" : (objPeril.tsiAmt == null ? "" : formatCurrency(objPeril.tsiAmt));
		$("varPerilTsiAmt").value 		= objPeril == null ? "" : objPeril.tsiAmt;
		$("premiumAmt").value			= objPeril == null ? "" : (objPeril.premAmt == null ? "" : formatCurrency(objPeril.premAmt));
		$("perilType").value			= objPeril == null ? "" : objPeril.perilType;
		$("perilTarfCd").value			= objPeril == null ? "" : objPeril.tarfCd;
		$("perilAnnTsiAmt").value		= objPeril == null ? "" : objPeril.annTsiAmt; 
		$("perilAnnPremAmt").value		= objPeril == null ? "" : objPeril.annPremAmt;
		$("perilPrtFlag").value			= objPeril == null ? "" : objPeril.prtFlag;
		$("perilRiCommRate").value		= objPeril == null ? "" : (objPeril.riCommRate == null ? "" : formatToNthDecimal(objPeril.riCommRate, 9)); 
		$("perilRiCommAmt").value		= objPeril == null ? "" : formatCurrency(objPeril.riCommAmt);
		$("perilSurchargeSw").value		= objPeril == null ? "" : objPeril.surchargeSw;
		$("perilBaseAmt").value			= objPeril == null ? "" : objPeril.baseAmt == null ? "" : formatCurrency(objPeril.baseAmt);
		$("perilAggregateSw").value		= objPeril == null ? "" : objPeril.aggregateSw;
		$("perilDiscountSw").value		= objPeril == null ? "" : objPeril.discountSw;
		$("perilNoOfDays").value 		= objPeril == null ? "" : objPeril.noOfDays;
		
		//$("tempPerilCd").value			= objPeril.perilCd;
		//$("tempPerilRate").value 		= formatToNineDecimal(objPeril.premRt);
		//$("tempTsiAmt").value			= formatCurrency(objPeril.tsiAmt);
		//$("tempPremAmt").value			= formatCurrency(objPeril.premAmt);
		//$("tempCompRem").value			= objPeril.compRem == null ? "" : changeSingleAndDoubleQuotes(objPeril.compRem);

		if (objUWParList.issCd != 'RI'){
			$("compRem").value	 = compRem;
		}else {
			$("compRemRi").value = compRem;
		}
		
		if ("Y" == $F("perilAggregateSw")){
			$("chkAggregateSw").checked = true;
		}
		if ("Y" == $F("perilDiscountSw")){
			$("chkDiscountSw").checked = true;
		}
		if ("Y" == $F("perilSurchargeSw")){
			$("chkSurchargeSw").checked = true;
		}
	}catch(e){
		showErrorMessage("supplyItemPerilInfos", e);
	}
}