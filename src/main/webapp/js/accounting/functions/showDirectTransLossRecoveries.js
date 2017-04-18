/**
 * Show Direct Trans Loss Recoveries module GIACS010
 * 
 * @author Jerome Orio 10.05.2010
 * @version 1.0
 * @param
 * @return
 */
function showDirectTransLossRecoveries() {
	new Ajax.Updater(
			"transBasicInfoSubpage",
			contextPath
					+ "/GIACLossRecoveriesController?action=showDirectTransLossRecoveries",
			{
				parameters : {
					globalGaccTranId : objACGlobal.gaccTranId,
					globalGaccBranchCd : objACGlobal.branchCd,
					globalGaccFundCd : objACGlobal.fundCd
				},
				asynchronous : false,
				evalScripts : true,
				onCreate : function() {
					showNotice("Loading Loss Recoveries...");
				},
				onComplete : function() {
					hideNotice("");
				}
			});
}