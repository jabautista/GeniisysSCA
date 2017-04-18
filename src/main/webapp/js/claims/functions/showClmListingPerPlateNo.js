/**
 * Description: Get GICLS268 (Claim Listing Per Plate No) (From Inquiry Menu)
 * @author Marvin 01.28.13
 * */
function showClmListingPerPlateNo(lineCd, sublineCd, polIssCd, issueYy, polSeqNo, renewNo){
	try{
		new Ajax.Updater("dynamicDiv", contextPath+"/GICLClaimsController", {
			parameters: {
				action : "showClmListingPerPolicy",
				lineCd: lineCd,
				sublineCd: sublineCd,
				polIssCd: polIssCd,
				issueYy: issueYy,
				polSeqNo: polSeqNo,
				renewNo: renewNo, 
				module: "GICLS250"
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: showNotice("Loading, please wait..."),
			onComplete: function(response){
				if(checkErrorOnResponse(response)) {
					null;
				}
			}
		});	
	}catch(e){
		showErrorMessage("showClmListingPerPolicy2", e);
	}
}