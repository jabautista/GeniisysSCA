/**
 * Assign new values for claim global parameters
 * @param obj - JSONObject that holds the values of the global parameters
 * @author Veronica V. Raymundo
 */

function setClaimGlobals(obj){
	try{
		if(nvl(obj.claimId, "") != ""){
			objCLMGlobal.claimId 	 = obj.claimId;
			// no need to assign new value 
			objCLMGlobal.claimNo	 = obj.claimNo; // i assign na rin para sa ibang modules - irwin
			objCLMGlobal.policyNo	 = obj.policyNo;
			objCLMGlobal.lossCatCd	 = obj.lossCatCd;
			objCLMGlobal.lossCatDes  = obj.dspLossCatDesc;
			objCLMGlobal.lineCode 	 = obj.lineCode;
			objCLMGlobal.lineName 	 = obj.lineName;
			objCLMGlobal.sublineCd   = obj.sublineCd;
			objCLMGlobal.issueYy     = obj.issueYy;
			objCLMGlobal.issueCode 	 = obj.issueCode;
			objCLMGlobal.issCd		 = obj.issueCode;
			objCLMGlobal.policyIssueCode  = obj.policyIssueCode;
			objCLMGlobal.policySequenceNo = obj.policySequenceNo;
			objCLMGlobal.polSeqNo	 = obj.policySequenceNo;
			objCLMGlobal.renewNo     = obj.renewNo;
			objCLMGlobal.claimYy     = obj.claimYy;
			objCLMGlobal.claimSequenceNo  = obj.claimSequenceNo;
			objCLMGlobal.assuredNo 	 = obj.assuredNo;
			objCLMGlobal.assuredName = obj.assuredName;
			objCLMGlobal.riCd 		 = obj.riCd;
			objCLMGlobal.strDspLossDate = obj.strDspLossDate;
			objCLMGlobal.strDspLossDate2 = obj.strDspLossDate2;
			objCLMGlobal.strLossDate2 = obj.strLossDate2; //belle 11.29.2012 obj.strDspLossDate2;
			objCLMGlobal.strExpiryDate2 = obj.strExpiryDate2;
			objCLMGlobal.strPolicyEffectivityDate2 = obj.strPolicyEffectivityDate2;
			objCLMGlobal.claimStatDesc  = obj.clmStatDesc;
			objCLMGlobal.totalTag		= obj.totalTag;
			objCLMGlobal.catastrophicCd = obj.catastrophicCode;
			objCLMGlobal.maxEndtSeqNo   = obj.maxEndorsementSequenceNumber;
			objCLMGlobal.strClaimFileDate = obj.strClaimFileDate;
			objCLMGlobal.claimFileDate  = obj.claimFileDate;
		}
	}catch(e){
		showErrorMessage("setClaimGlobals", e);
	}
}