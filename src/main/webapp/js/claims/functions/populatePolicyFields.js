function populatePolicyFields(obj){
	try{
		$("txtLineCd").value = $F("txtClmLineCd");
		$("txtSublineCd").value = obj.sublineCd;
		$("txtPolIssCd").value = obj.polIssCd;
		$("txtPolIssueYy").value = lpad(obj.polIssueYy, 2, "0");
		$("txtPolSeqNo").value  = lpad(obj.polSeqNo, 7, "0");
		$("txtPolRenewNo").value = lpad(obj.polRenewNo, 2, "0");
		//$("textItemNo").value =nvl(obj.itemNo,""); --robert sr 13692
		//$("textItemDesc").value = unescapeHTML2(obj.dspItemDesc); --robert sr 13692
		$("txtLossDate").value = obj.lossDate;
		//$("txtPlateNo").value = nvl(obj.plateNo,""); --robert sr 13692
		//$("txtPerilCd").value = nvl(obj.perilCd,""); --robert sr 13692
		//$("txtPerilName").value = unescapeHTML2(obj.dspPerilDesc); --robert sr 13692
		$("txtAssuredName").value = unescapeHTML2(obj.assuredName);
		
		// bonok :: 11.08.2013
		if(objCLMGlobal.callingForm == "GICLS260"){
			$("txtGICLS260AssuredName").value = unescapeHTML2(obj.assuredName);
			$("txtGICLS260LossDate").value = obj.lossDate;
		}
	}catch(e){
		showErrorMessage("populatePolicyFields",e);
	}
}