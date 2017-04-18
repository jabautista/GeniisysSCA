function showReserveRIDS(){
	var targetDiv = "ridsDiv";
	try{
		var histseqn = 0;
		if(objCurrGICLClmResHist == null){
			histseqn = 0;
		}else{
			histseqn = nvl(objLastGICLClmResHist.clmResHistId, 0);//nvl(objCurrGICLClmResHist.histSeqNo,0);
		}
		
		new Ajax.Updater(targetDiv, contextPath+"/GICLClaimReserveController",{
			method : "POST",
			parameters:{
				action: "getReserveRids",
				claimId: nvl(objCLMGlobal.claimId, 0),
				lineCd: objGICLClaims.lineCd,
				itemNo : nvl(objLastGICLClmResHist.itemNo,1),
				histSeqNo: histseqn,
				clmResHistId :objCurrReserveDS == null? "" : objCurrReserveDS.clmResHistId ,
				clmDistNo : objCurrReserveDS == null? "" : objCurrReserveDS.clmDistNo ,
				grpSeqNo : objCurrReserveDS == null? "" : objCurrReserveDS.grpSeqNo ,
				ajax : "1"
			},
			evalScripts: true,
			asynchronous: false,
			onCreate : function(){
				$(targetDiv).hide();
			},
			onComplete : function(){
				$(targetDiv).show();
			}
		});
		
	}catch(e){
		showErrorMessage("show reserve ri ds", e);
	}
}