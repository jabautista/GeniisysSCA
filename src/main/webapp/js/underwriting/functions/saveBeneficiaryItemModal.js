//jerome 05.12.10 for beneficiary info list in Accident Item Info Additional
function saveBeneficiaryItemModal(){
	new Ajax.Request(contextPath + "/GIPIWAccidentItemController?action=saveGipiParAccidentItem", {
		method : "POST",
		postBody : Form.serialize("itemInformationForm"),
		asynchronous : false,
		evalScripts : true,
		onCreate : function(){
			showNotice("Saving Beneficiary list details, please wait...");
		},
		onComplete : function(response){
			if (checkErrorOnResponse(response)) {
				hideNotice(response.responseText);							
				$("tempVariable").value = tempVar; // bring back the value of tempVariable
			}
		}
	});	
}