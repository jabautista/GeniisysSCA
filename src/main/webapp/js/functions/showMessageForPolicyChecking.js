/* These are functions needed for assured maintenance */
/* Created by		: Angelo
 * Date Created		: 01.05.2011
 */
//function showMessageForPolicyChecking(){ --rmanalad test-case 4.12.2011
function showMessageForPolicyChecking(overideSw){
	if (checkIfPolicyExists($F("assuredNo"))){
		var lineNames = "";
		for (var i = 0; i < objLines.length; i++){
			if (i != objLines.length - 1){
				lineNames = lineNames + objLines[i].lineName + ", ";
			} else {
				lineNames = lineNames + objLines[i].lineName;
			}
		}
		if (overideSw != 'Y'){ //-- rmanalad test-case 4.12.2011
			showConfirmBox('EDIT ASSURED', 'You are about to modify an assured with an existing ' + lineNames + ' policy.',
							"Continue", "Cancel",
							continueMaintainAssured, goToAssuredListing);
		}else{
			continueMaintainAssured();
		}
	} else {	
		if (overideSw != 'Y'){ //-- rmanalad test-case 4.12.2011
			showWaitingMessageBox('You are allowed to edit the assured and assured type.', imgMessage.INFO, continueMaintainAssured);
		}
		//continueMaintainAssured();
		
		//showConfirmBox('EDIT ASSURED', 'You are about to modify an assured without an existing policy.', rmanalad test-case 4.12.2011		
				//"Continue", "Cancel",
				//continueMaintainAssured, goToAssuredListing);

	}
}