function checkDisplayGiexs006(title){
	new Ajax.Request(contextPath+"/GIISDocumentController",{
		method: "GET",
		parameters: {
			action : "checkDisplayGiexs006",
			title  : title
		},
		evalScripts: true,
		asynchronous: true,
		onComplete: function(response){
			if(checkErrorOnResponse(response)){
				if(response.responseText == 'N'){
					 if(title == "DISPLAY_REASON_FOR_NR"){
						reasonSw = "N";
					}else if(title == "DISPLAY_REASON_FOR_RENEWAL"){
						renewSw = "N";
					}else if(title == "DISPLAY_CONTACT_INFO"){
						infoSw ="N";
					}
				}else{
					if(title == "DISPLAY_REASON_FOR_NR"){
						reasonSw = "Y";
					}else if(title == "DISPLAY_REASON_FOR_RENEWAL"){
						renewSw = "Y";
					}else if(title == "DISPLAY_CONTACT_INFO"){
						infoSw = "Y";
					}
				}
			}
		}
	});
}