function doParExit(){
	try {
		if(changeTag == 1) {
			if (changeTagFunc == null || changeTagFunc == undefined || changeTagFunc == ""){
				changeTag = 0;
				changeTagFunc = "";
				//clearObjectValues(objUWGlobal);
				goBackToPackagePARListing();
				objTempUWGlobal = null; // andrew - 09.08.2011
			}else{
				showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
						function(){
							changeTagFunc(); 
							if (changeTag == 0){
								changeTagFunc = "";
								//clearObjectValues(objUWGlobal);
								goBackToPackagePARListing();
							}
						}, 
						function(){
							changeTag = 0;
							changeTagFunc = "";
							goBackToPackagePARListing();
							objTempUWGlobal = null; // andrew - 09.08.2011
						}, 
						"");
			}	
		}else{
			changeTag = 0;
			changeTagFunc = "";
			goBackToPackagePARListing();
			objTempUWGlobal = null; // andrew - 09.08.2011
		}
	} catch (e) {
		showErrorMessage("doParExit", e);
	}
}