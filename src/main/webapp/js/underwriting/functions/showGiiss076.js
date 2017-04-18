//Intermediary Maintenance : shan 11.11.2013
function showGiiss076(intmNo, addEditSw){ 
	try{
		new Ajax.Request(contextPath + "/GIISIntermediaryController", {
			parameters : {
				action : "showGiiss076",
				intmNo:	 intmNo,
				addEditSw:	addEditSw
			},
			onCreate : showNotice("Loading Intermediary Maintenance, please wait..."),
			onComplete : function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					$("mainContents").update(response.responseText);
					if (addEditSw == "ADD"){
						disableButton("btnDelete");
						$("oldIntmNo").readOnly = false;
						$("prntIntmTinSw").value = "N";
						$("specialRate").value = "N";
						$("corpTag").value = "N";
						$("licTag").value = "N";
					}else{
						enableButton("btnDelete");
						$("oldIntmNo").readOnly = true;
					}
				}
			}
		});
	}catch(e){
		showErrorMessage("showGiiss076",e);
	}
}