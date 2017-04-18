/**
 * Checks the cosignor DB for matching id
 * mode: "P" for principal; "C" for cosignor
 */
function validatePrincipalORCoSignorId(id, mode, assdNo){
	var matched = false;
	new Ajax.Request(contextPath+"/GIISPrincipalSignatoryController",{
		method: "GET",
		evalScripts: true,
		asynchronous: false,
		parameters: {
			action: "validatePrincipalORCoSignorId",
			mode: mode,
			id: id,
			assdNo : assdNo   //added by Halley 10.07.13
		},onCreate: function(){
			//showNotice("Validating Id please wait..");
		},onComplete: function(response){
			//hideNotice();
			if(checkErrorOnResponse(response)){
				if(response.responseText != "0"){  //replaced == 1 to != 0 in cases of more than one matching result - Halley 09.30.2013
					matched =  true;
				}	
			}
		}
	});
	return matched;
}
/** END OF PRINCIPAL SIGNATORY**/