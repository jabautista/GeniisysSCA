//benjo 08.03.2016 SR-5512
function showIntreatyListing(lineCd, trtyYy, shareCd){
	try{
		new Ajax.Request(contextPath + "/GIRIIntreatyController?action=showIntreatyListing", {
			parameters : {
				lineCd : lineCd,
				trtyYy : trtyYy,
				shareCd : shareCd
			},
			asynchronous : false,
			evalScripts : true,
			onCreate : function() {
				showNotice("Loading, please wait...");
			},
			onComplete : function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					$("mainContents").update(response.responseText);
				}
			}
		});
	}catch(e){
		showErrorMessage("showIntreatyListing", e);
	}
}