function checkGipis095PackPeril(parId,itemNo) {  //added by steven 10.18.2013
	try{
		var result = "0";
		if (parId != null) {
			new Ajax.Request(contextPath + "/GIPIPackPARListController", {
				parameters : {action : "checkGipis095PackPeril",
							  parId : parId,
							  itemNo : itemNo
							},
				evalScripts:true,
				asynchronous: false,
//				onCreate : showNotice("Loading, please wait..."),
				onComplete : function(response){
//					hideNotice();
					if(checkErrorOnResponse(response)){
						if (response.responseText != "0") {
							result = response.responseText;
						}
					}
				}
			});
		}
		return result;
	}catch(e){
		showErrorMessage("checkGipis095PackPeril",e);
	}
}