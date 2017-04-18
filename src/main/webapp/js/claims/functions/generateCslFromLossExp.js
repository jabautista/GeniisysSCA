function generateCslFromLossExp(cslList){
	try{
		new Ajax.Request(contextPath+"/GICLEvalCslController", {
			asynchronous: false,
			parameters:{
				action: "generateCslFromLossExp",
				cslList: prepareJsonAsParameter(cslList)
			},
			onCreate: function(){
				showNotice("Processing, please wait...");
			},
			onComplete: function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					if(nvl(response.responseText, "SUCCESS") == "SUCCESS"){
						/*showGenericPrintDialog("Print CSL", function(){
							printCSL(cslList,"GICLS030");
						});*/
						cslTableGrid.refresh();
						clearCslRelatedTableGrids();
					}else{
						showMessageBox(response.responseText, "E");
					}
				}else{
					showMessageBox(response.responseText, "E");
				}
			}
		});
	}catch(e){
		showErrorMessage("generateCslFromLossExp", e);
	}
}