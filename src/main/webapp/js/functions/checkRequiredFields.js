// check if required fields are all field out (all input fields that has class="required")
// Whofeih - 06.23.2010
function checkRequiredFields() {
	var isComplete = true;
	$$(".required").each(function (o) {
		if (o.value.blank()) {
			isComplete = false;
			$break;
		}
	});
	
	return isComplete;
}