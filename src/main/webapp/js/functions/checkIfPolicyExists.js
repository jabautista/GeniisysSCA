function checkIfPolicyExists(assdNo){
	var isExists = false;

	if (getPolicyLinesForAssured() != ""){
		isExists = true;
	}

	return isExists;
}