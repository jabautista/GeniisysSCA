function checkIfPolicyExistsTG(assdNo){
	var isExists = false;

	if (getPolicyLinesForAssuredTG(assdNo) != ""){
		isExists = true;
	}

	return isExists;
}