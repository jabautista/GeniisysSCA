/**
 * @author rey
 * @date 10-17-2011
 * @param itemNo
 */
function getPersonnelList(itemNo,ajax){
	try{
		new Ajax.Updater("personnelCaInfoGrid", contextPath+"/GICLCasualtyDtlController",{
			parameters : {
				action: 	"getPersonnel",
				lineCd: 	objCLMGlobal.lineCd,
				sublineCd: 	objCLMGlobal.sublineCd,
				polIssCd: 	objCLMGlobal.policyIssueCode,
				issueYy: 	objCLMGlobal.issueYy,
				polSeqNo: 	objCLMGlobal.policySequenceNo,
				renewNo: 	objCLMGlobal.renewNo,
				polEffDate: dateFormat(objCLMGlobal.polEffDate, "mm-dd-yyyy"),
				expiryDate: dateFormat(objCLMGlobal.strExpiryDate, "mm-dd-yyyy"),
				lossDate: 	dateFormat(objCLMGlobal.strLossDate, "mm-dd-yyyy"),
				inceptDate: dateFormat(objCLMGlobal.inceptDate, "mm-dd-yyyy"),
				itemNo: 	itemNo,
				ajax: 		ajax,
				claimId:	objCLMGlobal.claimId
			},
			asynchronous: false, 
			evalScripts: true,
			onComplete: function(response){
				if (checkErrorOnResponse(response)) {
					null;
				}
			}
		});	
	}
	catch(e){
		showErrorMessage("getPersonnelList",e);
	}
}