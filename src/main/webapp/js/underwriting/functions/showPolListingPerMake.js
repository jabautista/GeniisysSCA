//John Dolon 9.16.2013
function showPolListingPerMake(){
	try{
		new Ajax.Request(contextPath+"/GIPIVehicleController",{
			parameters: {
				action: "showPolListingPerMake"
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: function (){
				showNotice("Loading, please wait...");
			},
			onComplete: function(response){
				hideNotice();
				if (checkErrorOnResponse(response)){
					$("mainContents").update(response.responseText);
				}
			}
		});
	}catch(e){
		showErrorMessage("showCTPLPolicyListing", e);
	}
}