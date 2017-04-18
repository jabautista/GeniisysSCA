function saveReserveDs(){
	try{
		var targetDiv = "reserveDsGrid";
		var claimId = objCLMGlobal.claimId;
		var lineCd = objCLMGlobal.lineCd;
		var clmResHistId = objCurrGICLClmResHist.clmResHistId;
		var clmDistNo = "1"; 
		var grpSeqNo = "1";
		var distYear = $F("distYearTxt");
		var perilCd = objCurrGICLClmResHist.perilCd;
		var histSeqNo = objCurrGICLClmResHist.histSeqNo;
		var shareType = "1";
		var dspTrtyName = $F("treatyNameTxt");
		var shrPct = $F("shrPctTxt");
		var itemNo = objCurrGICLItemPeril.itemNo;
		var shrLossResAmt = $F("shrLossResAmtTxt").replace(/,/g, '');
		var shrExpResAmt = $F("shrExpResAmtTxt").replace(/,/g, ''); 
		var cpiRecNo = "1";
		var groupedItemNo = nvl(objCurrGICLClmResHist.groupedItemNo, 0);
		var cpiBranchCd = "1";
		
		new Ajax.Updater(targetDiv, contextPath + "/GICLClaimReserveController?action=saveReserveDs", {
			method: "POST",
			parameters:{
				claimId: claimId,
				lineCd: lineCd,
				clmResHistId: clmResHistId,
				clmDistNo: clmDistNo, 
				itemNo: itemNo,
				grpSeqNo: grpSeqNo,  
				distYear: distYear, 
				dspTrtyName: dspTrtyName,
				perilCd: perilCd, 
				histSeqNo: histSeqNo, 
				shareType: shareType,
				shrPct: shrPct, 
				shrLossResAmt: shrLossResAmt, 
				shrExpResAmt: shrExpResAmt, 
				cpiRecNo: cpiRecNo,	
				groupedItemNo: groupedItemNo,
				cpiBranchCd: cpiBranchCd 
			}, 
			asynchronous: false,
			evalJS: true,
			onCreate: function(){
				showNotice("Saving, please wait...");
			},
			onComplete: function(response){
				hideNotice("");
			}
		});
	}catch(e){
		showErrorMessage("saveReserveDs", e);
	}
}