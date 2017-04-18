/** Check changeTag before going to Underwriting Main.
 *  Modules: GIPIS001, GIPIS001A, GIPIS058 and GIPIS058A
 * @author Veronica V. Raymundo
 * @return
 */
function checkChangeTagBeforeUWMain(){
	if(changeTag == 1) {
		if (changeTagFunc == null || changeTagFunc == undefined || changeTagFunc == ""){
			changeTag = 0;
			changeTagFunc = "";
			clearParParameters();
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
		}else{
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						changeTagFunc(); 
						endRedistributionTransaction();
						if (changeTag == 0){
							changeTagFunc = "";
							clearParParameters();
							goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
						}
					}, 
					function(){
						changeTag = 0;
						changeTagFunc = "";
						clearParParameters();
						endRedistributionTransaction();
						goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);	
					}, 
					"");
		}	
	}else{
		changeTag = 0;
		changeTagFunc = "";
		clearParParameters();
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	}
}