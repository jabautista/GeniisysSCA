function retrieveDtlCSL(clmLossId){
	try{
		new Ajax.Updater("dtlCslTableGridDiv", contextPath+"/GICLLossExpDtlController",{
			method : "POST",
			parameters:{
				action: "getDtlCslList",
				claimId: nvl(objCLMGlobal.claimId, 0),
				clmLossId: nvl(clmLossId, 0),
				lineCd: objCLMGlobal.lineCd,
				ajax : "1"
			},
			evalScripts: true,
			asynchronous: false,
			onCreate : function(){
				$("dtlCslTableGridDiv").hide();
			},
			onComplete : function(){
				$("dtlCslTableGridDiv").show();
			}
		});		
	}catch(e){
		showErrorMessage("retrieveDtlCSL", e);
	}
}