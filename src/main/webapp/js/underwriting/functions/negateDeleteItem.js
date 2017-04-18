function negateDeleteItem(){
	if($F("globalBackEndt") == "Y"){
		new Ajax.Request(contextPath + "/GIPIItemMethodController?action=checkBackEndtBeforeDelete", {
			method : "GET",
			parameters : {
				parId : (objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId")),
				itemNo : $F("itemNo")
			},
			asynchronous : true,
			evalScripts : true,
			onCreate : function(){
				 //showNotice("Checking if item is backward endorsement. Please wait...");
			},
			onComplete : function(response){
				//hideNotice("Done!");
				if(checkErrorOnResponse(response)){
					if(response.responseText != "SUCCESS"){
						showMessageBox(response.responseText, imgMessage.INFO);
						stopProcess();
					}else{						
						endtDeleteDiscount();
					}
				}				
			}
		});	
	}else{
		endtDeleteDiscount();
	}		
}