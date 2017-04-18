function makeRecordReadOnly(className) {
	$$("." + className).each(function(i) {

		i.readOnly = true;
		if (i instanceof HTMLSelectElement) {
			i.disabled = true;
		}
	});
}