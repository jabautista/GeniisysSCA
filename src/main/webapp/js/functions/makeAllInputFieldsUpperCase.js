// make all input fields and textareas uppercase
// provided because there are instances that a form requires all fields to be all CAPS
function makeAllInputFieldsUpperCase() {
	$$("input[type='text'], textarea").each(function (e) {
		if (e.id != "email"){	//added by angelo 01.20.11 to avoid automatic capitalization of email
			e.observe("keyup", function () {
				e.value = e.value.toUpperCase();
			});
		}
	});
}