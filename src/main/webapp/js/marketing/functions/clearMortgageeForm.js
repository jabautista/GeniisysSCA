/**
 * @return
 */
function clearMortgageeForm(){
	$("selMortgagee").options[$("selMortgagee").selectedIndex].innerHTML = "";
	$("selMortgagee").options[$("selMortgagee").selectedIndex].value = "";
	$("selMortgagee").options[$("selMortgagee").selectedIndex].setAttribute("mortgCd", "");
	$("selMortgagee").selectedIndex = 0;
	$("txtMortgageeAmount").value = 0;
	$("txtMortgageeItemNo").value = $F("txtItemNo");
	$("btnAddMortgagee").value = "Add";
}