function isPerilOpen(flag){
	if(flag == "CLOSE" || flag == "DENIED" || flag == "WITHDRAWN" || flag == "CLOSED" || flag == "DENIED"){
		return false;
	}
	return true;
}