/**
 * Show Other Trans Withholding Tax module GIACS022
 * 
 * @author eman 11.30.2010
 * @return
 */
function showOtherTransWithholdingTax() {
	new Ajax.Updater(
			"transBasicInfoSubpage",
			contextPath
					+ "/GIACTaxesWheldController?action=showOtherTransWithholdingTaxTableGrid",
			{ // replace:showOtherTransWithholdingTax replace
				// to:showOtherTransWithholdingTaxTableGrid by steven 06.07.2012
				method : "GET",
				parameters : {
					gaccTranId : objACGlobal.gaccTranId,
					gaccBranchCd : objACGlobal.branchCd,
					ajax : 1
				},
				asynchronous : true,
				evalScripts : true,
				onCreate : function() {
					showNotice("Loading Withholding Tax...");
				},
				onComplete : function() {
					hideNotice("");
				}
			});
}