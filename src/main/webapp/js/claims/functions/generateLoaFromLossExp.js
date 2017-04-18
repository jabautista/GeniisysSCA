function generateLoaFromLossExp(loaList){
	try{
		new Ajax.Request(contextPath+"/GICLEvalLoaController", {
			asynchronous: false,
			parameters:{
				action: "generateLoaFromLossExp",
				loaList: prepareJsonAsParameter(loaList)
			},
			onCreate: function(){
				showNotice("Processing, please wait...");
			},
			onComplete: function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					if(nvl(response.responseText, "SUCCESS") == "SUCCESS"){
						/*showGenericPrintDialog("Print CSL", function(){
							printLOA(loaList,"GICLS030");
						});*/
						loaTableGrid.refresh();
						clearLoaRelatedTableGrids();
					}else{
						showMessageBox(response.responseText, "E");
					}
				}else{
					showMessageBox(response.responseText, "E");
				}
			}
		});
	}catch(e){
		showErrorMessage("generateLoaFromLossExp", e);
	}
}