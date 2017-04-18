// moved from additionalEngineeringInfo.jsp
// modified by Christian Santos 07/05/2012
function prepareENParams() {
	try{
		var enParams = new Object();
		
		enParams.parId = (objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId"));
		enParams.projTitle = $F("enProjectName");
		enParams.siteLocation = $F("enSiteLoc");
		enParams.consStartDate = $F("constructFrom");
		enParams.consEndDate = $F("constructTo");
		enParams.maintStartDate = $F("mainFrom");
		enParams.maintEndDate = $F("mainTo");
		enParams.weeksTest = $F("weeksTesting");
		enParams.mbiPolNo = $F("mbiPolNo");
		enParams.timeExcess = $F("timeExcess");
		
		return JSON.stringify(enParams);
	}catch(e){
		showErrorMessage("prepareENParams", e);
	}
}