/* emman 05.04.10
 * update peril info fields
 * /underwriting/invoiceCommission.jsp
 */
function updatePerilFields(row) {
	$("inputPerilCd").value = row.down("input", 1).value;
	$("inputPerilName").value = changeSingleAndDoubleQuotes(row.down("input", 2).value);
	$("inputPerilPremAmt").value = formatCurrency(row.down("label", 1).innerHTML);
	$("inputPerilRate").value = formatToNthDecimal(row.down("label", 2).innerHTML, 7);
	$("inputPerilCommAmt").value = formatCurrency(row.down("label", 3).innerHTML);
	$("inputPerilWholdingTax").value = formatCurrency(row.down("label", 4).innerHTML);
	$("inputPerilNetComm").value = formatCurrency(row.down("label", 5).innerHTML);
	$("inputVarRate").value = row.down("input", 8).value;		
}