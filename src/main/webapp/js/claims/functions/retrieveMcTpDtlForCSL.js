function retrieveMcTpDtlForCSL(){
	try{
		new Ajax.Updater("mcTpDtlTableGridDiv", contextPath+"/GICLMcTpDtlController",{
			method : "POST",
			parameters:{
				action: "getMcTpDtlForCSL",
				claimId: nvl(objCLMGlobal.claimId, 0),
				ajax : "1"
			},
			evalScripts: true,
			asynchronous: false,
			onCreate : function(){
				$("mcTpDtlTableGridDiv").hide();
			},
			onComplete : function(){
				$("mcTpDtlTableGridDiv").show();
			}
		});		
	}catch(e){
		showErrorMessage("retrieveMcTpDtlForCSL", e);
	}
}