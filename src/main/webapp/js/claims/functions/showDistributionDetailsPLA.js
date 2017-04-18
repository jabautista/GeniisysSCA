/**
 * Shows Preliminary Loss Advice - Distribution Details
 * Module: GICLS028
 * @author Niknok Orio
 * @date 02.16.2012
 */
function showDistributionDetailsPLA(obj){
	try{
		new Ajax.Updater("distDetailsMainDiv", contextPath + "/GICLReserveDsController", {
			parameters: {	
				action: 	 	"showDistDetailsPLA",
				claimId: 	 	obj == null ? "" :nvl(obj.claimId,objCLMGlobal.claimId),
				lineCd: 	 	obj == null ? "" :nvl(obj.lineCd,objCLMGlobal.lineCd),
				clmResHistId: 	obj == null ? "" :nvl(String(obj.clmResHistId),""),
				itemNo:			obj == null ? "" :nvl(String(obj.itemNo),""),
				groupedItemNo:	obj == null ? "" :nvl(String(obj.groupedItemNo),""),
				perilCd:		obj == null ? "" :nvl(String(obj.perilCd),""),
				histSeqNo:		obj == null ? "" :nvl(String(obj.histSeqNo),"")
			}, 
			asynchronous: false,
			evalScripts: true, 
			onComplete: function (response){
				if(checkErrorOnResponse(response)){
					null;
				}
			}
		});
	}catch(e){
		showErrorMessage("showDistributionDetailsPLA", e);
	}	
}