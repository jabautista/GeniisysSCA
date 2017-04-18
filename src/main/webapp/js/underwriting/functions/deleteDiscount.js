//DELETE_DISCOUNT of Endt Par Item Info
function deleteDiscount() {
	var result = true;
	var action = "deleteDiscount";
	
	if ($F("globalParType") == "E") {
		action = action + "2";
	}
	
	new Ajax.Request(contextPath + "/GIPIItemMethodController?action="+action,{
		method : "GET",
		parameters : {
			globalParId : $F("globalParId")
		},					
		asynchronous : false,
		evalScripts : true,
		onCreate: function() {
			//showNotice("Deleting discount. Please wait...");
		},
		onComplete : function(response){
			//hideNotice("Done!");
			var msg = response.responseText;
			if (msg == "SUCCESS") {
				//$("varExpiryDate").value = expiry;
				result = true;
			} else {
				showMessageBox(msg, imgMessage.ERROR);
				result = false;
			}
		}
	});

	return result;
}