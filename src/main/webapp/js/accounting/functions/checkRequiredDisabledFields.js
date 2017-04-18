function checkRequiredDisabledFields() {
	var isComplete = true;
	$$(".required").each(function(o) {
		if (o.value.blank() && o.disabled == false) {
			isComplete = false;
			$break;
		}
	});
	return isComplete;
}