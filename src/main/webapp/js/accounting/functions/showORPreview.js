/**
 * Display the OR Preview
 * 
 * @author Jerome Orio 11.30.2010
 * @version 1.0
 * @return
 */
function showORPreview() {
	new Ajax.Updater("transBasicInfoSubpage", contextPath
			+ "/GIACOpTextController?action=showORPreview", {
		parameters : {
			globalGaccTranId : objACGlobal.gaccTranId,
			globalGaccBranchCd : objACGlobal.branchCd,
			globalGaccFundCd : objACGlobal.fundCd,
			page : 1
		},
		asynchronous : true, // set asynchoronous to true to allow hiding of
								// notice message for OR Preview by MAC
								// 05/30/2013.
		evalScripts : true,
		onCreate : function() {

			showNotice("Loading OR Preview...");
		},
		onComplete : function() {
			hideNotice("");
		}
	});
}