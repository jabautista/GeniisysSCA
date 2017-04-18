/* emman 05.04.10
 * clear peril fields
 * /underwriting/invoiceCommission.jsp
 */
function clearPerilFields() {
	$("inputPerilCd").value = "";
	$("inputPerilName").value = "";
	$("inputPerilPremAmt").value = "0.00";
	$("inputPerilRate").value = 0;
	$("inputPerilCommAmt").value = "0.00";
	$("inputPerilWholdingTax").value = "0.00";
	$("inputPerilNetComm").value = "0.00";

	disableButton("btnSavePeril");
}