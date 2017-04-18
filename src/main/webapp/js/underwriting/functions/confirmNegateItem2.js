function confirmNegateItem2(){
	var itemNo = new Number($F("itemNo"));
	
	showConfirmBox("Negate Item", "Negate/Remove Item will automatically negate all perils of item number " + itemNo.toPaddedString(3) + 
			", which means that it is deleted. Do you want to continue?", "Yes", "No", confirmNegateItem3, stopProcess);
}