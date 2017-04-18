function onSelectDeductibleLossExp(obj){
	try{
		$("txtDedLossExpCd").value 	 = unescapeHTML2(obj.lossExpDesc);
		$("txtDedLossExpCd").setAttribute("dedLossExpCd", obj.lossExpCd);
		if(nvl($("hidDedSublineCd").value, "") == "" || nvl($("hidDedType").value, "") == "L"){
			$("txtDedBaseAmt").value = formatCurrency(obj.dtlAmt);
			fireEvent($("txtDedBaseAmt"), "change");
		}
	}catch(e){
		showErrorMessage("onSelectDeductibleLossExp", e);	
	}
}