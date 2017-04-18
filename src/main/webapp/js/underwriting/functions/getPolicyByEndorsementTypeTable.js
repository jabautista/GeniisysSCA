/**
 * @author rey
 * @date 07-19-2011
 * @param endorsement
 */
function getPolicyByEndorsementTypeTable(endtType){
	
	new Ajax.Updater("policyByEndorsementTypeDiv","GIPIPolbasicController?action=getPolicyListByEndorsementType",{
		method:"get",
		evalScripts: true,
		parameters: {
		  endtType:	endtType
		}
	});
	
}