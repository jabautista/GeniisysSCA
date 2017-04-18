function getMcEvalCslDtlTGList(obj){
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
		new Ajax.Updater("cslDtlDiv",contextPath+"/GICLEvalCslController", {
			parameters: {
				action: 'getMcEvalCslDtlTGList',
				evalId : (obj == null ? "" : obj.evalId),
				payeeTypeCd: (obj == null ? "" : obj.payeeTypeCd),
				payeeCd: (obj == null ? "" : obj.payeeCd)
			},								
			asynchronous: false,
			evalScripts: true,
			onCreate: showLoading("cslDtlDiv", "Getting CSL Details..", "150px"),	
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