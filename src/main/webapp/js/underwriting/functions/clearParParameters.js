function clearParParameters(){
	/*if ($("globalParId").value != "0"){
		$("globalParId").value = "0";
		$("globalPolFlag").value = "";
		$("globalAssignSw").value = "";
		$("globalParStatus").value = "0";
		$("globalParSeqNo").value = "";
		$("globalAssdNo").value = "";
		$("globalAssdName").value = "";
		$("globalParYy").value = "";
		$("globalParType").value = "";
		$("globalRemarks").value = "";
		$("globalUnderwriter").value = "";
		$("globalQuoteId").value = "0";
		$("globalParNo").value = "";
		$("globalPackParId").value = "0";
		$("globalPackParNo").value = "";
		$("globalLineCd").value = "";
		$("globalSublineCd").value = "";
		$("globalIssCd").value = "";
		$("globalQuoteSeqNo").value = "";
		$("globalPackPolFlag").value = "";
		$("globalRenewNo").value = "";
		$("globalParSeqNoC").value = "";
	}*/
	$("uwParParametersDiv").update("<form id='uwParParametersForm' name='uwParParametersForm'>"+
			"<input type='hidden' name='globalParId' 		id='globalParId' 		value='0'/>"+
			"<input type='hidden' name='globalQuoteId' 		id='globalQuoteId' 		value='0'/>"+
			"<input type='hidden' name='globalParStatus' 	id='globalParStatus' 	value='0'/>"+
			"<input type='hidden' name='globalPolFlag' 		id='globalPolFlag' 		value='0'/>"+
			"<input type='hidden' name='globalOpFlag' 		id='globalOpFlag' 		value='0'/></form>");
	
	objUWParList = null;
	objGIPIWPolbas = null;
	objUWGlobal.lineCd = null;
	objUWGlobal.menuLineCd = null;
}