/**
 * Show Dist by TSI/Prem (Peril) - GIUWS017
 * @author niknok
 * @since 07.28.2011
 */
function showDistByTsiPremPeril(params,loadRec){ //steven 06.11.2014
	try{
		new Ajax.Updater("mainContents", contextPath+"/GIPIPolbasicPolDistV1Controller", {
			method: "GET",
			parameters: {
				action : "showDistByTsiPremPeril",
				params : JSON.stringify(nvl(params,null)),
				loadRec : nvl(loadRec,'N')
			},
			evalScripts: true,
			asynchronous: false,
			onCreate: function(){
				showNotice("Getting Distribution by TSI/Prem (Peril), please wait...");
			},
			onComplete: function(response){
				if (checkErrorOnResponse(response)) {	
					hideNotice();
				}
			}
		});
	}catch(e){
		showErrorMessage("showDistByTsiPremPeril", e);
	}
}