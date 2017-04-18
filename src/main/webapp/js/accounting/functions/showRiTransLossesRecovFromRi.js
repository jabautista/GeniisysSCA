/**
 * Display the RI Trans - Losses Recov From RI
 * 
 * @author Jerome Orio 10.21.2010
 * @version 1.0
 * @return
 */
function showRiTransLossesRecovFromRi() {
	new Ajax.Updater(
			"transBasicInfoSubpage",
			contextPath
					+ "/GIACLossRiCollnsController?action=showRiTransLossesRecovFromRiTableGrid&ajax=1",
			{ // replace: showRiTransLossesRecovFromRi replace to:
				// showRiTransLossesRecovFromRiTableGrid by steven 06.07.2012
				parameters : {
					globalGaccTranId : objACGlobal.gaccTranId,
					globalGaccBranchCd : objACGlobal.branchCd,
					globalGaccFundCd : objACGlobal.fundCd
				},
				asynchronous : false,
				evalScripts : true,
				onCreate : function() {
					showNotice("Loading Losses Recov from RI...");
				},
				onComplete : function() {
					hideNotice("");
				}
			});
}