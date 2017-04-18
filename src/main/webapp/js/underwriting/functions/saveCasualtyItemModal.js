//jerome 04.25.10 for grouped items and personnel info list in Casualty Item Info Additional
function saveCasualtyItemModal(){
	new Ajax.Request(contextPath + "/GIPIWCasualtyItemController?action=saveGipiParCasualtyItem", {
		method : "POST",
		postBody : Form.serialize("itemInformationForm"),
		asynchronous : false,
		evalScripts : true,
		onCreate :  function(){
			showNotice("Saving Grouped/Personnel list details, please wait...");
		},
		onComplete : function(response){
			if (checkErrorOnResponse(response)) {
				hideNotice(response.responseText);							
				$("tempVariable").value = tempVar; // bring back the value of tempVariable
			}
		}
	});	
}