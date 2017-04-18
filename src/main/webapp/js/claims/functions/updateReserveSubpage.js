function updateReserveSubpage(claimId, itemNo, perilCd){
	new Ajax.Updater("claimReserveSectionDiv", "GICLClaimReserveController",{
		method: "POST",
		parameters:{
			action: "getClaimReserve",
			claimId: nvl(claimId,0),
			itemNo: nvl(itemNo,0),
			perilCd: nvl(perilCd, 0)
		},
		evalScripts: true,
		asynchronous: false,
		onCreate: function(){
			$("claimReserveSectionDiv").hide();
		},
		onComplete: function(){
			$("claimReserveSectionDiv").show();
		}
	});
}