//angelo 4.27.2011 marine cargo additional info
function setQuoteMNAdditional(itemObj){
	try {
		var newObj = {};
		newObj.quoteId			= nvl(itemObj.quoteId,'');
		newObj.itemNo			= nvl($F("txtItemNo"),'');
		newObj.geogCd			= escapeHTML2($("geogCd").value);
		newObj.cargoType		= escapeHTML2($("cargoType").value); 			
		newObj.cargoClassCd		= escapeHTML2($("cargoClassCd").value);		
		newObj.packMethod		= escapeHTML2($("packMethod").value); 			
		newObj.blAwb			= escapeHTML2($("blAwb").value); 				
		newObj.transhipOrigin	= escapeHTML2($("transhipOrigin").value);		
		newObj.transhipDestination = escapeHTML2($("transhipDestination").value); 	
		newObj.voyageNo			= escapeHTML2($("voyageNo").value); 			
		newObj.lcNo				= escapeHTML2($("lcNo").value); 				
		newObj.etd				= escapeHTML2($("etd").value); 					
		newObj.eta				= escapeHTML2($("eta").value); 					
		newObj.printTag			= escapeHTML2($("printTag").value); 			
		newObj.origin			= escapeHTML2($("origin").value); 				
		newObj.destn			= escapeHTML2($("destn").value); 				
		newObj.vesselCd			= escapeHTML2($("vesselCd").value);				
		return newObj;
	}catch (e) {
		showErrorMessage("setQuoteMNAdditional", e);
	}
}