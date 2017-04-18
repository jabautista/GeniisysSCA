//Update Block Details (from underwriting menu) : shan 12.06.2013
function showGipis155(){ 
	try{
		new Ajax.Request(contextPath + "/UpdateUtilitiesController", {
			parameters : {
					action : 	"getGipis155FireItemListing"
			},
			onCreate : showNotice("Loading Update Policy District/Block/EQ/FLD/TPN/TRF, please wait..."),
			onComplete : function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					$("mainContents").update(response.responseText);
				}
			}
		}); 
	}catch(e){
		showErrorMessage("showGipis155",e);
	}
}