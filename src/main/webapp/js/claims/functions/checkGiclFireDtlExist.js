/**
 * Description: Check if gicl_fire_dtl exist
 * @author Niknok 10.10.11
 * */
function checkGiclFireDtlExist(){
	try{
		var exist = "N";
		new Ajax.Request(contextPath+"/GICLFireDtlController",{
			parameters: {
				action: "getGiclFireDtlExist",
				claimId: objCLMGlobal.claimId
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response){
				if(checkErrorOnResponse(response)) {
					exist = response.responseText;
				}
			}
		});
		return exist;
	}catch(e){
		showErrorMessage("checkGiclFireDtlExist", e);
	}
}