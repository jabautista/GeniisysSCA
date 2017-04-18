function getMcItemPeril(claimId, itemNo){
	try{
		new Ajax.Request(contextPath + "/GICLMcEvaluationController", {
			parameters:{
				action: "getMcItemPeril",
				claimId :claimId,
				itemNo: itemNo,
			},
			asynchronous: false,
			evalScripts: true,
			//onCreate: showNotice("Please wait.."),
			onComplete: function(response){
				//hideNotice("");
				if(checkErrorOnResponse(response)) {
					var res = JSON.parse(response.responseText);
					if(nvl(res.multiplePerils ,"N") == "Y"){
						enableSearch("txtPerilCdIcon");
					}else{
						$("txtPerilName").value = unescapeHTML2(res.perilName);
						$("txtPerilCd").value = res.perilCd;
						disableSearch("txtPerilCdIcon");
					}
				}
				
			}});
	}catch(e){
		showErrorMessage("getMcItemPeril",e);
	}
}