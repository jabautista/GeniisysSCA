function retrieveDtlLOA(clmLossId){
	try{
		new Ajax.Updater("dtlLoaTableGridDiv", contextPath+"/GICLLossExpDtlController",{
			method : "POST",
			parameters:{
				action: "getDtlLoaList",
				claimId: nvl(objCLMGlobal.claimId, 0),
				clmLossId: nvl(clmLossId, 0),
				lineCd: objCLMGlobal.lineCd,
				ajax : "1"
			},
			evalScripts: true,
			asynchronous: false,
			onCreate : function(){
				$("dtlLoaTableGridDiv").hide();
			},
			onComplete : function(){
				$("dtlLoaTableGridDiv").show();
			}
		});		
	}catch(e){
		showErrorMessage("retrieveDtlLOA", e);
	}
}