/*
 * function that will display the total tax amount based from selected premium
 * payment record @author Alfie Niño Bioc 11.26.2010
 * 
 * @version 1.0 @param @return
 */

function displayTotalTaxAmount(totalTaxAmount) {
	$("lblListTotalTaxAmount").innerHTML = formatCurrency(totalTaxAmount);
}