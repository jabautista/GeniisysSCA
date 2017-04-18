function populateVatDetails(obj){
	try{
		$("dspCompany").value = obj== null ? "" : unescapeHTML2(obj.dspCompany);
		$("dspPartLabor").value = obj== null ? "" : unescapeHTML2(obj.dspPartLabor);
		$("vatAmt").value = obj== null ? "" : formatCurrency(obj.vatAmt);
		$("vatRate").value = obj== null ? "" : formatCurrency(obj.vatRate);
		$("baseAmt").value = obj== null ? "" : formatCurrency(obj.baseAmt);
		if(obj!= null){
			if(obj.lessDed == "Y"){
				$("lessDed").checked = true;
			}else{
				$("lessDed").checked = false;
			}	
			
			if(obj.lessDep == "Y"){
				$("lessDep").checked = true;
			}else{
				$("lessDep").checked = false;
			}	
		}else{
			$("lessDed").checked = false;
			$("lessDep").checked = false;
			disableSearch("dspPartLaborIcon");
		}
		$("payeeTypeCd").value = obj== null ? "" : obj.payeeTypeCd;
		$("payeeCd").value = obj== null ? "" : obj.payeeCd;
		$("applyTo").value = obj== null ? "" : obj.applyTo;
		$("paytPayeeTypeCd").value = obj== null ? "" : obj.paytPayeeTypeCd;
		$("paytPayeeCd").value = obj== null ? "" : obj.paytPayeeCd;
		$("netTag").value = obj== null ? "" : obj.netTag;
		
		if(variablesObj.giclEvalVatAllowUpdate == "Y"){
			if(obj == null){
				$("btnAddVat").value = "Add";
				disableButton("btnDelVat");
			}else{
				$("btnAddVat").value = "Update";
				enableButton("btnDelVat");
			}
		}else{
			$("lessDed").disabled = "disabled";
			$("lessDep").disabled = "disabled";
			disableSearch("dspCompanyIcon");
			disableSearch("dspPartLaborIcon");
		}
	}catch(e){
		showErrorMessage("populateVatDetails",e);
	}
}