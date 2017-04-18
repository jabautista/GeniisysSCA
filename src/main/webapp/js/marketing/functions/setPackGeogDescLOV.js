/**
 * Sets list of values for Geography Description 
 * in Marine Cargo Additional Information
 */

function setPackGeogDescLOV(quoteId){
	new Ajax.Request(contextPath+"/GIPIQuotationMarineCargoController", {
		method : "GET",
		parameters: {
			action: "getQuoteMNGeographyDescListing",
			quoteId: quoteId
		},
		onComplete: function(response){
			if(checkErrorOnResponse(response)){
				var result = JSON.parse(response.responseText);
				for(var i=0; i<result.length; i++){
					var geogDescObj = result[i];
					$("geogCd").insert("<option value='"+geogDescObj.geogCd+"' quoteId='"+quoteId+"'>"+geogDescObj.geogDesc+"</option>");
				}
			}
		}
	});
}