/**
 * Created By Irwin Tabisora. 4.25.2011
 * */
function updatePackQuotationParameters(){
	try {
		
		new Ajax.Request(contextPath+"/GIPIPackQuoteController?action=setPackQuoteParameters", {
			method: "POST",
			asynchronous: true,
			evalScripts: true,
			parameters: {action: "setPackQuoteParameters",
						packQuoteId:   (objMKGlobal.packQuoteId != null ? objMKGlobal.packQuoteId : $F("globalPackQuoteId"))}, 
			 			//   packQuoteId : $F("globalPackQuoteId")},
			onComplete: function(response) {
							 if(checkErrorOnResponse(response)){
								 $("mkQuotationParameters").update(response.responseText);							 
							 } else {
								showMessageBox(response.responseText, imgMessage.ERROR);
							 }
						}
		});
	} catch (e){
		showErrorMessage("updatePackQuotationParameters", e);
	}	
}