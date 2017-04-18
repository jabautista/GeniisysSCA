/**
 * Sets list of values for Carrier 
 * in Marine Cargo Additional Information
 */

function setPackCarrierLOV(quoteId){
	new Ajax.Request(contextPath+"/GIPIQuotationMarineCargoController", {
		method : "GET",
		parameters: {
			action: "getQuoteMNCarrierListing",
			quoteId: quoteId
		},
		onComplete: function(response){
			if(checkErrorOnResponse(response)){
				var result = JSON.parse(response.responseText);
				for(var i=0; i<result.length; i++){
					var carrierObj = result[i];
					$("vesselCd").insert("<option value='"+carrierObj.vesselCd+"' quoteId='"+quoteId+"'>"+carrierObj.vesselName+"</option>");
				}
			}
		}
	});
}