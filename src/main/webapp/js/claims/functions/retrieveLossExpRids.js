function retrieveLossExpRids(giclLossExpDs){
	try{		
		new Ajax.Updater("lossExpRidsTableGridDiv", contextPath+"/GICLLossExpRidsController",{
			method : "POST",
			parameters:{
				action: "getGiclLossExpRidsList",
				claimId: nvl(giclLossExpDs.claimId, 0),
				clmLossId: nvl(giclLossExpDs.clmLossId, 0),
				clmDistNo : nvl(giclLossExpDs.clmDistNo, 0),
				grpSeqNo: nvl(giclLossExpDs.grpSeqNo, 0),
				ajax : "1"
			},
			asynchronous : false,
			evalScripts : true,
			onCreate : function(){
				$("lossExpRidsTableGridDiv").hide();
			},
			onComplete : function(){
				$("lossExpRidsTableGridDiv").show();
			}
		});		
	}catch(e){
		showErrorMessage("retrieveLossExpRids", e);
	}
}