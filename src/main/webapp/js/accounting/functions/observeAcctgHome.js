function observeAcctgHome(saveFunc) {
	$("home").stopObserving("click");
	$("home").observe(
			"click",
			function() {
				if (changeTag == 1) {
					showConfirmBox4("Confirmation",
							objCommonMessage.WITH_CHANGES, "Yes", "No",
							"Cancel", function() {
								goToModule(
										"/GIISUserController?action=goToHome",
										"Home");
								saveFunc();
								changeTag = 0;
							}, function() {
								changeTag = 0;
								goToModule(
										"/GIISUserController?action=goToHome",
										"Home");
							}, "");
				} else {
					goToModule("/GIISUserController?action=goToHome", "Home");
				}
			});
}