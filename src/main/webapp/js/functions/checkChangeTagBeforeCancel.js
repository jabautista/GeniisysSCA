// added function for cancel buttons
// add this on observe of btnCancel elements
function checkChangeTagBeforeCancel() {	
	if (changeTagFunc != "") {
		changeTagFunc();
	}
}