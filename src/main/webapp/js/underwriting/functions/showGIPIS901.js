function showGIPIS901(tab){
	try{
		new Ajax.Request(contextPath+"/GIPIGenerateStatisticalReportsController", {
			parameters: {
				action: 	"showGIPIS901",
				tab: 		tab
			},
			onCreate: function(){
				tab == "statisticalTab" ? showNotice("Loading Generate Statistical Reports, please wait...") : showNotice("Loading, please wait...");
			},
			onComplete : function(response){
				hideNotice("");
				if(checkErrorOnResponse(response)){					
					tab == "statisticalTab" ?  $("dynamicDiv").update(response.responseText) : $("statisticalReportsDiv").update(response.responseText);
				}
			}
		});	
	}catch(e){
		showErrorMessage("showGIPIS901", e);
	}
}