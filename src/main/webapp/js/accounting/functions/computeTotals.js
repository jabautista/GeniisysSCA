/**
 * Computes Premium Total GIACS007
 * 
 * @author tonio sept 10,2010
 * @version 1.0
 */
function computeTotals() {
	try {
		var collnsTotal = 0;
		var premTotal = 0;
		var taxTotal = 0;

		for (i = 0; i < objAC.jsonDirectPremCollnsDtls.length; i++) {
			if (objAC.jsonDirectPremCollnsDtls[i].recordStatus != -1) {
				collnsTotal += convertToNumber(objAC.jsonDirectPremCollnsDtls[i].collAmt);
				premTotal += convertToNumber(objAC.jsonDirectPremCollnsDtls[i].premAmt);
				taxTotal += convertToNumber(objAC.jsonDirectPremCollnsDtls[i].taxAmt);
			}
			// });
		}
		$("lblCollnsTotal").innerHTML = formatCurrency(collnsTotal);
		$("lblPremTotal").innerHTML = formatCurrency(premTotal);
		$("lblTaxTotal").innerHTML = formatCurrency(taxTotal);
		objAC.maxCollAmt = collnsTotal;
		objAC.sumGtaxAmt = taxTotal;
	} catch (e) {
		showErrorMessage("computeTotals", e);
		// showMessageBox("computeTotals : " + e.message);
	}
}