/**
 * Casualty item check location.
 * 
 * @author J. Diago
 * @param
 */
function checkLocationOfLoss(){
	try{
		var ok = true;
		
		if (nvl(objCLMItem.vLocLossCA,"") == ""){
			showMessageBox("VALIDATE LOCATION OF LOSS does not exist in GIIS_PARAMETERS.", "E");
			ok = false;
		}
		
		if (nvl(objCLMItem.vLocLossCA,"") == "Y"){
			showWaitingMessageBox("Location from Basic information is not the same for the chosen item's location.", "W",
					function(){
						clearClmItemForm();
					});
			ok = false;
		}
		
		if (nvl(objCLMItem.vLocLossCA,"") == "N"){
			showConfirmBox("Confirm", "Location from Basic information is not the same for the chosen item's location. Do you wish to continue?",
					"Yes", "No", addClmItem, clearClmItemForm);
		}
		
		if (nvl(objCLMItem.vLocLossCA,"") == "O"){
			if (!validateUserFunc2("VL", "GICLS016") || validateUserFunc2("VL", "GICLS016") == false){
				showConfirmBox("Confirm", "Location from Basic information is not the same for the chosen item's location. Do you want to override?", "Yes", "No", 
						function(){
							objAC.funcCode = "VL";
							objACGlobal.calledForm = "GICLS016";
							commonOverrideOkFunc = function(){
								ok = true;
								addClmItem();
							};
							commonOverrideNotOkFunc = function(){
								showWaitingMessageBox($("overideUserName").value + " is not allowed to Override.", "E", 
										clearOverride);
								ok = false;
							};
							commonOverrideCancelFunc = function(){
								ok = false;
								clearClmItemForm();
							};
							getUserInfo();
							$("overlayTitle").innerHTML = "Override User";
						},
						clearClmItemForm
					);
			} else {
				ok = true;
				addClmItem();
			}
		}
	} catch(e) {
		showErrorMessage("checkLocationOfLoss", e);
	}
}