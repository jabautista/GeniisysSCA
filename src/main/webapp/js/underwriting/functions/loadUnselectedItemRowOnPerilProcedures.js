function loadUnselectedItemRowOnPerilProcedures(){
	try {
		disableButton("btnCopyPeril");
		$("perilGroupExists").value = "N";
		$("chkAggregateSw").disabled = false;
		$("perilPackageCd").value = "";
		$("vOldPlan").value = "";
		clearItemPerilFields();
		$("varPackPlanSw").value 	= "";
		$("varPackPlanCd").value 	= "";
		$("varPlanSw").value 		= "";
		$("vOra2010Sw").value 		= "";
		$("perilRate").readOnly = false;
		$("premiumAmt").readOnly = false;
		$("perilPackageCd").enable();
		$$("div[name='itemPerilMotherDiv']").each(function(a){
			a.hide();
			$("perilTotalTsiAmt").value = formatCurrency(0);
			$("perilTotalPremAmt").value = formatCurrency(0);
		});
	} catch(e){
		showErrorMessage("loadUnselectedItemRowOnPerilProcedures", e);
	}
}