function checkIfCancelPARCreation(){
	if ($F("cancelPressed") == "Y"){
		clearParParameters();
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	}
}