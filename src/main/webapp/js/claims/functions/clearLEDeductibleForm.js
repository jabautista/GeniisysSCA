function clearLEDeductibleForm(){
	$("txtLossExpCd").value = ""; 
	$("txtLossExpCd").setAttribute("lossExpCd", "");
	$("txtDedLossExpCd").value = "";
	$("txtDedLossExpCd").setAttribute("dedLossExpCd", "");
	$("txtDedBaseAmt").value = "";
	$("txtDedRate").value = "";
	$("txtDeductibleType").value = "";
	$("txtDeductibleType").setAttribute("dedType", "");
	$("txtDedUnits").value = "";
	$("txtDeductibleText").value = "";
	$("txtDeductibleAmt").value = "";
	$("hidDedSublineCd").value = "";
	$("hidDedType").value = "";
	$("hidDedCompSw").value = "";
	$("hidDedAggregateSw").value = "";
	$("hidDedCeilingSw").value = "";
	$("hidDedMinAmt").value = "";
	$("hidDedMaxAmt").value = "";
	$("hidDedRangeSw").value = "";
}