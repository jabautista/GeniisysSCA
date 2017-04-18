//make all input fields and textareas that has class upper uppercase
//provided because there are instances that a field required to be all CAPS
function makeInputFieldUpperCase() {
	$$("input[type='text'], textarea").each(function (e) {
		if (e.hasClassName("upper")) {
			e.observe("keyup", function () {
				e.value = e.value.toUpperCase();
			});
		}
	});
}