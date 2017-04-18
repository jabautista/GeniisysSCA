//jerome 04.25.10 for carrier list in Marine Cargo Item Info Additional
function saveCarrierModal(){
	new Ajax.Request(contextPath + "/GIPIWCargoController?action=saveGipiParMarineCargoItem", {
		method : "POST",
		postBody : Form.serialize("itemInformationForm"),
		asynchronous : false,
		evalScripts : true,
		onCreate : 
			function(){
				showNotice("Saving carrier list details, please wait...");
			},
		onComplete : function(response){
			if (checkErrorOnResponse(response)) {
				hideNotice(response.responseText);
				$("tempVariable").value = tempVar; // bring back the value of tempVariable
			}
		}
	});	
}