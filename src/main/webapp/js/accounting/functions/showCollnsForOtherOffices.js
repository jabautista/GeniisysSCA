/**
 * Show Collections For Other Offices module GIACS012
 * 
 * @author Nica Raymundo 12.13.2010
 * @return
 */
function showCollnsForOtherOffices() {
	// new Ajax.Updater("transBasicInfoSubpage",
	// contextPath+"/GIACCollnsForOtherOfficeController?action=showCollnsForOtherOffices",
	// {
	new Ajax.Updater(
			"transBasicInfoSubpage",
			contextPath
					+ "/GIACCollnsForOtherOfficeController?action=showCollnsForOtherOfficesTableGrid",
			{
				method : "GET",
				parameters : {
					gaccTranId : objACGlobal.gaccTranId,
					gaccBranchCd : objACGlobal.branchCd,
					ajax : '1'
				},
				asynchronous : true,
				evalScripts : true,
				onCreate : function() {
					showNotice("Loading Unidentified Collections...");
				},
				onComplete : function() {
					hideNotice("");
				}
			});
}