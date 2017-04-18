function populateEvalSumFields(obj){
	try{
		$("replaceGross").value = obj == null? null : formatCurrency(nvl(obj.replaceGross,"0"));
		$("replaceAmt").value = obj == null? null : formatCurrency(obj.replaceAmt);
		$("repairGross").value = obj == null? null : formatCurrency(nvl(obj.repairGross,"0"));
		$("repairAmt").value = obj == null? null : formatCurrency(obj.repairAmt);
		$("vat").value = obj == null? null : formatCurrency(obj.vat);
		$("totErc").value = obj == null? null : formatCurrency(obj.totErc);
		$("deductible").value = obj == null? null : formatCurrency(obj.deductible);
		$("depreciation").value = obj == null? null : formatCurrency(obj.depreciation);
		$("dspDiscount").value = obj == null? null : formatCurrency(obj.dspDiscount); 
		
		$("totInp").value = obj == null? null : formatCurrency(obj.totInp); 
		$("totInl").value = obj == null? null : formatCurrency(obj.totInl); 
		$("dspCurrShortname").value = obj == null? null : obj.dspCurrShortname; 
		$("currencyRate").value = obj == null? null : formatCurrency(obj.currencyRate); 
	}catch(e){
		showErrorMessage("populateEvalSumFields",e);
	}
}