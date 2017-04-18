function checkErrorOnResponse(response) {
	if (response.responseText.include("UNHANDLED EXCEPTION")){
		showMessageBox(response.responseText.substring(23), "E");
		return false;
/* 	} else if (response.responseText.include("Exception occurred.") // andrew - 05.02.2011 - changed "Exception" to "Exception occured.", to avoid bug in texts in response containing the word Exception 
		//	|| response.responseText.include("exception") //added for different E cases BJGA12.22.2010
			){
		showMessageBox(response.responseText, imgMessage.ERROR);
		return false;
	}else if(response.responseText.include("exception occurred")){
		// irwin 5.18.11 - added to handle the new error message: "An exception occurred while processing the request. This may be caused by missing or invalid procedure."
		// add more statements if new error messages are made.
		showMessageBox(response.responseText, imgMessage.ERROR);
		return false;*/
	} else if ((response.responseText.include("Your session has expired."))) {
		showMessageBox(response.responseText, imgMessage.ERROR);
		return false;
	} else if(response.responseText.include("CSVOPTIONISNOTAVAILABLE")){
		var res = response.responseText.split("@");
		showMessageBox("CSV option is not available for this report (" + res[0] + ").", /*imgMessage.ERROR*/imgMessage.INFO);
		return false;
	} else {
		return true;
	}
}