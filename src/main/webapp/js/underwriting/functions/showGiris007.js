function showGiris007(){
	try{
		new Ajax.Request(contextPath+"/TreatyPerilsController", {
			method: "GET",
			parameters: {
				action : "showGiris007",
				callForm : objUWGlobal.module,
				shareType : objGiris007.shareType,
				lineCd : objGiris007.lineCd,
				trtyYy : objGiris007.trtyYy,
				shareCd : objGiris007.shareCd,
				layerNo : objGiris007.layerNo,
				proportionalTreaty : objGiris007.proportionalTreaty
			},
			evalScripts:true,
			asynchronous: true,
			onCreate: function (){
				showNotice("Loading, please wait...");
			},
			onComplete: function (response)	{
				hideNotice("");
				if(checkErrorOnResponse(response)){
					$("mainContents").update(response.responseText);
				}
			}
		});		
	}catch(e){
		showErrorMessage("showGiris007",e);
	}	
}