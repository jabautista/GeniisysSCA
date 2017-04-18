/* emman 05.04.10
 * update selected peril info then compute total commission
 * /underwriting/invoiceCommission.jsp
 */
function savePerilInfo() {
	$$("div[id='perilRow"+$("inputIntermediaryNo").value+"-"+$("inputItemGroup").value+"-"+$("inputTakeupSeqNo").value+"']").each(function (row) {			
		if (row.down("input", 1).value == $("inputPerilCd").value) {
			row.down("label", 1).innerHTML = formatCurrency($("inputPerilPremAmt").value);
			row.down("label", 2).innerHTML = formatCurrency($("inputPerilRate").value);
			row.down("label", 3).innerHTML = formatCurrency($("inputPerilCommAmt").value);
			row.down("label", 4).innerHTML = formatCurrency($("inputPerilWholdingTax").value);
			row.down("label", 5).innerHTML = formatCurrency($("inputPerilNetComm").value);
			row.down("input", 3).value = parseFloat($("inputPerilPremAmt").value.replace(/,/g,""));
			row.down("input", 4).value = parseFloat($("inputPerilRate").value);
			row.down("input", 5).value = parseFloat($("inputPerilCommAmt").value.replace(/,/g,""));
			row.down("input", 6).value = parseFloat($("inputPerilWholdingTax").value.replace(/,/g,""));
			row.down("input", 7).value = parseFloat($("inputPerilNetComm").value.replace(/,/g,""));
			computeTotalComm();
		}
	});
}