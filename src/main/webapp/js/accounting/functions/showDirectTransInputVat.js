
/**
 * Show Direct Trans Input Vat module GIACS039
 * 
 * @author Jerome Orio 09.20.2010
 * @version 1.0
 * @param
 * @return
 */
function showDirectTransInputVat() {
	new Ajax.Updater(
			"transBasicInfoSubpage",
			contextPath
					+ "/GIACInputVatController?action=showDirectTransInputVatTableGrid&ajax=1",
			{
				parameters : {
					globalGaccTranId : objACGlobal.gaccTranId,
					globalGaccBranchCd : objACGlobal.branchCd,
					globalGaccFundCd : objACGlobal.fundCd
				},
				asynchronous : false,
				evalScripts : true,
				onCreate : function() {
					showNotice("Loading Input Vat...");
				},
				onComplete : function() {
					hideNotice("");
				}
			});
}