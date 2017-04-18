function saveMortgagee(formName){		
	new Ajax.Request(contextPath + "/GIPIParMortgageeController?action=saveGipiParItemMortgagee&ajax=1", {
		method : "POST",
		postBody : Form.serialize(formName),
		asynchronous : true,
		evalScripts : true,
		onCreate : function(){
			showNotice("Saving, please wait...");
		},
		onComplete : function(response){
			if (checkErrorOnResponse(response)) {
				hideNotice(response.responseText);
				if(response.responseText == "SUCCESS"){
					//Modalbox.hide();
				}
			}
		}
	});
}