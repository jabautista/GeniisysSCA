	/* created by: steven
	 * date: 10/23/2012
	 */
function saveCopiedPeril(objItemPeril) {
	try{
		var objParameters = new Object();
		objParameters.setPerils = objItemPeril;
		new Ajax.Request(contextPath + "/GIPIWItemPerilController?action=saveCopiedPeril", {
			method : "POST",
			parameters : {
				parameters : JSON.stringify(objParameters),
				fromItemNo : $F("itemNo")
			},
			asynchronous: false,
			evalScripts: true,
			onCreate : 
				function(){
					showNotice("Saving Item Peril, please wait...");
				},
			onComplete : 
				function(response){	
					hideNotice();
					if(response.responseText != "SUCCESS"){
						showMessageBox(response.responseText, imgMessage.ERROR);
					}else{
						showMessageBox("Perils had been copied and saved to item no."+$F("destinationItem")+".", "info");
					}
				}
		});
		
	}catch(e){
		showErrorMessage("saveCopiedPeril", e);		
	}
}