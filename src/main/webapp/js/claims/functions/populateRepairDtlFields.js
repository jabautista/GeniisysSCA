function populateRepairDtlFields(obj){
	try{
		$("payeeTypeCd").value = obj== null ? "" : obj.payeeTypeCd;
		$("dspCompanyType").value = obj== null ? "" : unescapeHTML2(obj.dspCompanyType);
		$("payeeCd").value = obj== null ? "" : obj.payeeCd;
		$("dspCompany").value = obj== null ? "" : unescapeHTML2(obj.dspCompany);
		$("lpsRepairAmt").value = obj== null ? "" : formatCurrency(obj.lpsRepairAmt);
		$("actualTinsmithAmt").value = obj== null ? "" : formatCurrency(obj.actualTinsmithAmt);
		$("actualPaintingAmt").value = obj== null ? "" : formatCurrency(obj.actualPaintingAmt);
		$("actualTotalAmt").value = obj== null ? "" : formatCurrency(obj.actualTotalAmt);
		if(obj!= null){
			if(obj.withVat == "Y"){
				$("withVat").setAttribute("title","Inclusive Of Vat");
				$("withVat").checked = true;
			}else{
				$("withVat").setAttribute("title","Exclusive Of Vat");
				$("withVat").checked = false;
			}	
			
		}else{
			$("withVat").checked = false;
		}
		$("otherLaborAmt").value = obj== null ? "" : formatCurrency(obj.otherLaborAmt);
		$("dspTotalLabor").value = obj== null ? "" : formatCurrency(obj.dspTotalLabor); 
		$("dspTotalT").value =  obj== null ? "" : formatCurrency(obj.dspTotalT);
		$("dspTotalP").value =  obj== null ? "" : formatCurrency(obj.dspTotalP);
		
	
	}catch(e){
		showErrorMessage("populateReplaceDtlFields",e);
	}
}