function checkRequiredDisabledFields2() {
	var isComplete = true;
	$$(".required").each(
			function(o) {
				if (!(o instanceof HTMLImageElement)
						&& !(o instanceof HTMLDivElement)) {

					if (o.value.blank() && o.disabled == false
							&& o.style.display != "none") {
						isComplete = false;
						$break;
					}
				}
			});
	return isComplete;
}