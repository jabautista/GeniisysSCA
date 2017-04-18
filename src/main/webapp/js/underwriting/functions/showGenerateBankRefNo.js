function showGenerateBankRefNo(){
	try{
		new Ajax.Request(contextPath+"/GIPIRefNoHistController",{
			parameters: {
				action: "showGenerateBankRefNo"
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: function (){
				showNotice("Loading, please wait...");
			},
			onComplete: function(response){
				hideNotice();
				if (checkErrorOnResponse(response)){
					$("mainContents").update(response.responseText);
				}
			}
		});
	}catch(e){
		showErrorMessage("showGenerateBankRefNo", e);
	}
}