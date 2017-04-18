/**
 * Display the RI Trans Inward Facultative Premium Collections
 * 
 * @author Jerome Orio 08.03.2010
 * @version 1.0
 * @return
 */
function showRiTransInwFaculPremCollns() {
	new Ajax.Updater(
			"transBasicInfoSubpage",
			contextPath
					+ "/GIACInwFaculPremCollnsController?action=showInwFaculPremCollnsTableGrid&ajax=1",
			{ // maggie 03.26.2012 changed action parameter and added ajax
				// parameter for table grid listing
				parameters : {
					globalGaccTranId : objACGlobal.gaccTranId,
					globalGaccBranchCd : objACGlobal.branchCd,
					globalGaccFundCd : objACGlobal.fundCd
				},
				asynchronous : false,
				evalScripts : true,
				onCreate : function() {
					showNotice("Loading Inward Facultative Premium Collections...");
				},
				onComplete : function() {
					hideNotice("");
				}
			});
}