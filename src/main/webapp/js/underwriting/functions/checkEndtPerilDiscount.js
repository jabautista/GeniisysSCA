function checkEndtPerilDiscount(objArray){
	for(var i=0; i<objArray.length; i++){
		if(0 != objArray[i].discSum && null != objArray[i].discSum) {
			return true;
		}
	}
	return false;
}