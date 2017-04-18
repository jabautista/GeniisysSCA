function initializeAiType(btnElementId){
	$$(".aiInput").each(function(inputElement){
		inputElement.observe("change", function(){ // emsy 12.02.2011 ~ modified "click" to "change"
			$(btnElementId).removeClassName("disabledButton");
			enableButton(btnElementId); //robert 05.24.2012
			//$(btnElementId).addClassName("button"); //robert 05.24.2012
			objQuoteGlobal.hasPendingAdditional = true; //robert
		});
	});
	//emsy 12.21.2011
	$$(".hover").each(function(inputElement){
		inputElement.observe("click", function(){ 
			$(btnElementId).removeClassName("disabledButton");
			enableButton(btnElementId); //robert 05.24.2012
			//$(btnElementId).addClassName("button"); //robert 05.24.2012
			objQuoteGlobal.hasPendingAdditional = true; //robert
		}); 
	});
	//robert
	$$(".hover").each(function(inputElement){
		inputElement.observe("keypress", function(event){ 
			if (event.keyCode == 13){
				$(btnElementId).removeClassName("disabledButton");
				enableButton(btnElementId); 
				objQuoteGlobal.hasPendingAdditional = true; 
			}
		}); 
	});
}