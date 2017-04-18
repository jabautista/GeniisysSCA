/**
 * Fire item check block/district no.
 * 
 * @author Niknok Orio
 * @param
 */
function checkBlockDistrictNo(){
	try{
		var ok = true;
		
		if (nvl(objCLMItem.vLocLoss,"") == ""){
			showMessageBox("VALIDATE LOCATION OF LOSS does not exist in GIIS_PARAMETERS.", "E");
			ok = false;
		}
		
		if (nvl(objCLMItem.vLocLoss,"") == "Y"){
			showWaitingMessageBox("Block/District from Basic information is not the same for the chosen item Block/District.", "W",
					function(){
						clearClmItemForm();
					});
			ok = false;
		}
		
		if (nvl(objCLMItem.vLocLoss,"") == "N"){
			showConfirmBox("Confirm", "Block/District from Basic information is not the same for the chosen item Block/District. Do you wish to continue?",
					"Yes", "No", addClmItem, clearClmItemForm);
		}
		
		if (nvl(objCLMItem.vLocLoss,"") == "O"){
			if (!validateUserFunc2("VL", "GICLS015") || validateUserFunc2("VL", "GICLS015") == false){
				showConfirmBox("Confirm", "Block/District from Basic information is not the same with item Block/District. Do you want to override?", "Yes", "No", 
						function(){
							objAC.funcCode = "VL";
							objACGlobal.calledForm = "GICLS015";
							commonOverrideOkFunc = function(){
								ok = true;
								addClmItem();
							};
							commonOverrideNotOkFunc = function(){
								showWaitingMessageBox($("overideUserName").value + " is not allowed to Override.", "E", 
										clearOverride);
								ok = false;
								//clearClmItemForm();
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
			}else{
				ok = true;
				addClmItem();
			}
		}
		
		return ok;
	}catch(e){
		showErrorMessage("checkBlockDistrictNo", e);
	}
}