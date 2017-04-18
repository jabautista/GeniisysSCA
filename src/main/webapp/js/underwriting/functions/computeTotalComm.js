/* emman 05.04.10
 * compute total commission
 * /underwriting/invoiceCommission.jsp
 */
function computeTotalComm() {
	var premAmt = 0;
	var commAmt = 0;
	var netCommAmt = 0;
	var wholdingTax = 0;

	$$("div[id='perilRow"+$("inputIntermediaryNo").value+"-"+$("inputItemGroup").value+"-"+$("inputTakeupSeqNo").value+"']").each(function (row) {			
		premAmt = premAmt + parseFloat(row.down("label", 1).innerHTML.replace(/,/g,""));
		commAmt = commAmt + parseFloat(row.down("label", 3).innerHTML.replace(/,/g,""));
		netCommAmt = netCommAmt + parseFloat(row.down("label", 5).innerHTML.replace(/,/g,""));
		wholdingTax = wholdingTax + parseFloat(row.down("label", 4).innerHTML.replace(/,/g,""));
	});

	$("inputPremium").value = formatCurrency(premAmt);
	$("inputTotalCommission").value = formatCurrency(commAmt);
	$("inputNetCommission").value = formatCurrency(netCommAmt);
	$("inputTotalWithholdingTax").value = formatCurrency(wholdingTax);
	
	updateIntmInfo();
}