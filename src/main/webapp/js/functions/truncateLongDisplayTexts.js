function truncateLongDisplayTexts(elementType, rowName) {
	$$(elementType+"[name='"+rowName+"']").each(function (a) {
		if (a.innerHTML.length >= 40) {
			a.update(a.innerHTML.truncate(40, "40"));
		}
	});
}