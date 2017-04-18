function resetLeadPolicyItemGrpDependentRecords(){
	$("hidSelectedItemGrp").value = "";
	setLeadPolicyInvoiceFieldValues(null);
	if($("lpTaxesDiv").innerHTML != ""){
		hideAllTableGridRows(lpTaxesTableGrid);
		hideAllTableGridRows(lpTaxesTableGrid2);
	}
	if($("lpPerilDistDiv").innerHTML != ""){
		hideAllTableGridRows(lpInvPerlTableGrid);
		hideAllTableGridRows(lpInvPerlTableGrid2);
	}
	if($("lpInvCommDiv").innerHTML != ""){
		hideAllTableGridRows(lpIntrmdryTableGrid);
		hideAllTableGridRows(lpCommInvPerilTableGrid);
		hideAllTableGridRows(lpCommInvPerilTableGrid2);
		populateLeadPolicyCommInvFieldValues(null);
		populateLeadPolicyCommInvPerilNameFields(null);
	}
}