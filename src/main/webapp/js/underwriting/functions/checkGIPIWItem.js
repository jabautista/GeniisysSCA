//Check GIPIWitem
function checkGIPIWItem(){
	new Ajax.Request(contextPath + "/GIPIItemMethodController?action=checkGIPIWItem&checkBoth=0&itemNo="+$F("itemNo")+"&parId="+$F("globalParId"),{
		method : "POST",
		parameters : {
			checkBoth : 0 /* for false */,
			parId : $F("globalParId"),
			itemNo : $F("itemNo")				
		},
		//postBody : Form.serialize("itemInformationForm"),
		asynchronous : false,
		evalScripts : true,
		//onCreate : showNotice("Checking item table, please wait..."), //comment muna di kasi naghhide.. nok
		onComplete : 
			function(response){
				if (checkErrorOnResponse(response)) {
					//hideNotice("");
					if(response.responseText != 'Empty'){
						showMessageBox(response.responseText, imgMessage.ERROR);	/* E */
						$("tempVariable").value = 1;						
					}
				}				
			} 
	});
}