function checkIfGiclLossPayeesExist(payeeClassCd, payeeCd, payeeName, listName){
	try{
		var payeeType = $("selPayeeType").value;
		var objFilteredArr = objGICLLossExpPayees.filter(function(o){	
			                 return nvl(o.recordStatus, 0) != -1 && o.claimId == objCLMGlobal.claimId &&
			                 o.itemNo == objCurrGICLItemPeril.itemNo && o.perilCd == objCurrGICLItemPeril.perilCd &&
			                 o.payeeClassCd == payeeClassCd && o.payeeType == payeeType && o.payeeCd == payeeCd;});
		
		if(parseFloat(objFilteredArr.length) > 0){
			if(listName == "payee"){
				showWaitingMessageBox("The payee you entered already has a History.", "I", function(){
					$("payee").value = "";
					$("payee").setAttribute("payeeNo", "");
				});
			}else{
				showWaitingMessageBox("There are no more available " +listName +" for this claim.", "I", function(){
					$("payee").value = "";
					$("payee").setAttribute("payeeNo", "");
					$("payeeClass").value = "";
					$("payeeClass").setAttribute("payeeClassCd", "");
				});
			}
			return false;
		}else{
			$("payee").value = unescapeHTML2(nvl(payeeName , ""));
			$("payee").setAttribute("payeeNo", nvl(payeeCd, ""));
			return true;
		}
	}catch(e){
		showErrorMessage("checkIfGiclLossPayeesExist", e);
	}
}