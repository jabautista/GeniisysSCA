function getMcEvalLoaDtlTGList(obj){
	try{
		if(obj == null){
			$("evalId").value ="";
			$("payeeTypeCd").value ="";
			$("payeeCd").value ="";
		}else{
			$("evalId").value =obj.evalId;
			$("payeeTypeCd").value =obj.payeeTypeCd;
			$("payeeCd").value =obj.payeeCd;
		}
		new Ajax.Updater("loaDtlDiv",contextPath+"/GICLEvalLoaController", {
			parameters: {
				action: 'getMcEvalLoaDtlTGList',
				evalId : (obj == null ? "" : obj.evalId),
				payeeTypeCd: (obj == null ? "" : obj.payeeTypeCd),
				payeeCd: (obj == null ? "" : obj.payeeCd)
			},								
			asynchronous: false,
			evalScripts: true,
			onCreate: showLoading("loaDtlDiv", "Getting LOA Details..", "150px"),	
			onComplete: function(response){
				hideNotice("");
				if(checkErrorOnResponse(response)) {
					
				}else{
					showMessageBox(response.responseText, "E");
				}
			}
		});
	}catch(e){
		showErrorMessage("getMcEvalLoaDtlTGList",e);
	}
}