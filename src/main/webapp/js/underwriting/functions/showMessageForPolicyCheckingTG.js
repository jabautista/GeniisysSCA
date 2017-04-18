function showMessageForPolicyCheckingTG(overideSw, assdNo){
	if (checkIfPolicyExistsTG(assdNo)){
		var lineNames = "";
		for (var i = 0; i < objLines.length; i++){
			if (i != objLines.length - 1){
				lineNames = lineNames + objLines[i].lineName + ", ";
			} else {
				lineNames = lineNames + objLines[i].lineName;
			}
		}
		if (overideSw != 'Y'){ //-- rmanalad test-case 4.12.2011
			showWaitingMessageBox('You are allowed to edit the assured and assured type.', imgMessage.INFO, 
							function () {
								continueMaintainAssuredTG(assdNo);
							});
		}else{
			//continueMaintainAssuredTG(assdNo);
		}
	} else {	
		if (overideSw != 'Y'){ //-- rmanalad test-case 4.12.2011
			showWaitingMessageBox('You are allowed to edit the assured and assured type.', imgMessage.INFO, 
							function () {
								continueMaintainAssuredTG(assdNo);
							});
		}
	}
}