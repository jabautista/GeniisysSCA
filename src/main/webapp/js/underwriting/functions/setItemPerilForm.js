function setItemPerilForm(obj){
	try{
		/*
		var perilCd						= objPeril == null ? "" : objPeril.perilCd;//row.down("input", 3).value;
		var peril						= $("perilCd");
		var index = 0;
		var compRem = null;
		
		for (var j=0; j<peril.length; j++){
			if (peril.options[j].value == perilCd){
				index = j;
			}
		}
		*/
		var lineCd = getLineCd();
		
		$("perilCd").value 				= obj == null ? "" : obj.perilCd;		
		$("txtPerilName").value			= obj == null ? "" : unescapeHTML2(obj.perilName);
		$("txtPerilCd").value			= obj == null ? "" : obj.perilCd;
		$("perilRate").value 		    = obj == null ? "" : (obj.premRt == null ? "" : formatToNineDecimal(obj.premRt));
		$("perilTsiAmt").value			= obj == null ? "" : (obj.tsiAmt == null ? "" : formatCurrency(obj.tsiAmt));
		$("varPerilTsiAmt").value 		= obj == null ? "" : obj.tsiAmt;
		$("premiumAmt").value			= obj == null ? "" : (obj.premAmt == null ? "" : formatCurrency(obj.premAmt));
		$("perilType").value			= obj == null ? "" : obj.perilType;
		$("perilTarfCd").value			= obj == null ? "" : obj.tarfCd;
		$("txtPerilTarfDesc").value		= obj == null ? "" : obj.tarfCd;
		$("perilAnnTsiAmt").value		= obj == null ? "" : obj.annTsiAmt; 
		$("perilAnnPremAmt").value		= obj == null ? "" : obj.annPremAmt;
		$("perilPrtFlag").value			= obj == null ? "" : obj.prtFlag;
		$("perilRiCommRate").value		= obj == null ? "" : (obj.riCommRate == null ? "" : formatToNthDecimal(obj.riCommRate, 9)); 
		$("perilRiCommAmt").value		= obj == null ? "" : formatCurrency(obj.riCommAmt);
		$("perilSurchargeSw").value		= obj == null ? "" : obj.surchargeSw;
		$("perilBaseAmt").value			= obj == null ? "" : obj.baseAmt == null ? "" : formatCurrency(obj.baseAmt);
		$("perilAggregateSw").value		= obj == null ? "" : obj.aggregateSw;
		$("perilDiscountSw").value		= obj == null ? "" : obj.discountSw;
		$("perilNoOfDays").value 		= obj == null ? "" : obj.noOfDays;
		$("chkAggregateSw").checked		= obj == null ? false : (obj.aggregateSw == "Y" ? true : false);
		$("chkDiscountSw").checked		= obj == null ? false : (obj.discountSw == "Y" ? true : false);
		$("chkSurchargeSw").checked		= obj == null ? false : (obj.surchargeSw == "Y" ? true : false);
		$("bascPerlCd").value 			= obj == null ? "" : obj.bascPerlCd; // added by: Nica 05.07.2012
		$("btnAddItemPeril").value		= obj == null ? "Add" : "Update";

		if (objUWParList.issCd != 'RI'){
			$("compRem").value	 = obj == null ? "" : unescapeHTML2(obj.compRem);
		}else {
			$("compRemRi").value = obj == null ? "" : unescapeHTML2(obj.compRem);
		}
		
		if(obj == null){
			$("hrefPeril").show();
			$("hrefPerilTarfCd").show();
			disableButton($("btnDeletePeril"));
		}else{
			$("hrefPeril").hide();
			$("hrefPerilTarfCd").hide();
			enableButton($("btnDeletePeril"));
		} 
		
		if(objGIISPeril!= null && objGIISPeril.length > 0){
			
			if(obj != null && obj.totalNoOfRecords > 0) //added by Apollo Cruz 09.10.2014 (temp solution)
				disableButton("btnCreatePerils");
			else
				enableButton("btnCreatePerils");
			
		}else{
			disableButton("btnCreatePerils");
		}
		
		if((tbgItemPeril != null || tbgItemPeril != undefined) && tbgItemPeril.geniisysRows.length > 0){
			enableButton("btnCopyPeril");
		}else{
			disableButton("btnCopyPeril");
		}		
		
		if(lineCd == "AC"){			
			$("perilPackageCd").value = $F("accidentPackBenCd");
		}
		
		//hideToolbarButtonInTG(tbgItemPeril);
		clearChangeAttribute("addItemPerilContainerDiv");
	}catch(e){
		showErrorMessage("setItemPerilForm", e);
	}
}