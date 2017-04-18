/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	11.18.2011	mark jm			set the observer for save, cancel, and exit button in item screens
 */
function observeItemMainFormButtons(){
	try{
		observeReloadForm("reloadForm", showItemInfo);
		
		observeCancelForm("btnCancel", 
			function(){
				objFormMiscVariables.saveOnly = false; 
				validateSaving(false);}, 
			function(){
				objFormMiscVariables.saveOnly = true; 
				objUWGlobal.packParId != null && objUWGlobal.packParId != undefined ? showPackParListing() : showParListing(); 
			});
		
		observeSaveForm("btnSave", function(){
			if($F("globalParStatus") > 5 && (objUWGlobal.parItemPerilChangeTag == 1 || getAddedAndModifiedJSONObjects(objGIPIWItemPeril).length > 0))//Added by Apollo Cruz 09.11.2014 
				showConfirmBox("Confirmation", "Changes will automatically recreate Invoice. Would you like to continue?", "Yes", "No", function(){validateSaving(true);}, null);
			else	
				validateSaving(true);		
		});
		
		$("parExit").stopObserving("click");
		
		$("parExit").observe("click", function(){
			$("btnCancel").click();
		});
	}catch(e){
		showErrorMessage("observeItemMainFormButtons", e);
	}
}