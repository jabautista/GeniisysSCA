function clearPackParParameters(){
	$("uwParParametersDiv").update("<form id='uwParParametersForm' name='uwParParametersForm'>"+
			"<input type='hidden' name='globalPackParId' 		id='globalPackParId' 		value='0'/>"+
			"<input type='hidden' name='globalQuoteId' 		id='globalQuoteId' 		value='0'/>"+
			"<input type='hidden' name='globalParStatus' 	id='globalParStatus' 	value='0'/>"+
			"<input type='hidden' name='globalPackPolFlag' 		id='globalPackPolFlag' 		value='0'/>"+
			"<input type='hidden' name='globalOpFlag' 		id='globalOpFlag' 		value='0'/></form>");
	
	objUWParList = null;
	objGIPIWPolbas = null;
}