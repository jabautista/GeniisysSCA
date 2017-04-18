/**
 * Shows Preliminary Loss Advice - PLA Details
 * Module: GICLS028
 * @author Niknok Orio
 * @date 02.16.2012
 */
function showPLADetails(claimId, grpSeqNo, clmResHistId, shareType){
	try{
		new Ajax.Updater("plaDetailsMainDiv", contextPath + "/GICLAdvsPlaController", {
			parameters: {	
				action: 	 	"showPLADetails",
				claimId: 	 	nvl(claimId,""),
				grpSeqNo: 	 	nvl(String(grpSeqNo),""),
				clmResHistId: 	nvl(String(clmResHistId),""),
				shareType:		nvl(String(shareType),"") 
			}, 
			asynchronous: false,
			evalScripts: true, 
			onComplete: function (response){
				if(checkErrorOnResponse(response)){
					getClaimsMenuProperties(true);
				}
			}
		});
	}catch(e){
		showErrorMessage("showPLADetails", e);
	}	
}