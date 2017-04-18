function populatePackPolicyNo(field){
	var policyNo = "";
	
	if(objUWGlobal != null){
		if(nvl(objUWGlobal.lineCd, "") != "" && nvl(objUWGlobal.sublineCd, "") != "" && nvl(objUWGlobal.issCd, "") != ""
		   && nvl(objUWGlobal.issueYy, "") != "" && nvl(objUWGlobal.polSeqNo, "") != ""){
			
			policyNo = objUWGlobal.lineCd + " - " + objUWGlobal.sublineCd + " - " + objUWGlobal.issCd + " - "
	  		 		   + parseInt(objUWGlobal.issueYy).toPaddedString(2) + " - " + parseInt(objUWGlobal.polSeqNo).toPaddedString(7) + " - " + parseInt(objUWGlobal.renewNo).toPaddedString(2);
		}
	}
	$(field).value = policyNo;
	$(field).title = policyNo;
}