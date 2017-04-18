function onSuccessfulSave(){
	try{
		var isPack = objUWGlobal.packParId != null && objUWGlobal.packParId != undefined ? true : false;
										
		showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
			clearAllItemRelatedObjects();
			objUWGlobal.parItemPerilChangeTag = 0; // Apollo Cruz 09.11.2014
			if(objFormMiscVariables.saveOnly == undefined || objFormMiscVariables.saveOnly == null){											
				lastAction == null ? showItemInfo() : lastAction();																					
			}else{											
				(!(objFormMiscVariables.saveOnly)) ? (isPack ? showPackParListing() : showParListing()) : showItemInfo();												
			}
		});
		
		if(isPack){ // andrew - 07.08.2011 - to update na package par parameters
			updatePackParParameters();
		} else {
			updateParParameters();	
		}
	}catch(e){
		showErrorMessage("onSuccessfulSave", e);
	}
}