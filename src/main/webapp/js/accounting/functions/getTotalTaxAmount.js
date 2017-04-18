/**
 * function that will get the total tax amount based from selected premium
 * payment record
 * 
 * @author Alfie Niño Bioc 11.26.2010
 * @version 1.0
 * @param
 * @return
 */

function getTotalTaxAmount(taxRows) {
	var totalTaxAmount=0;
	$$("div[name='taxRow']").each(function(taxRow){
		if (objACGlobal.gaccTranId+taxRow.down("label",1).innerHTML+taxRow.down("label", 2).innerHTML+taxRow.down("label", 3).innerHTML+taxRow.down("label", 0).innerHTML == taxRows) {
			totalTaxAmount 	= totalTaxAmount + parseFloat(Math.abs((taxRow.down("label", 5).innerHTML.replace(/,/g, ""))));
		}
	});
	return totalTaxAmount;
}