/**
 * @param itemPeril
 */
function setReserveEditableProperty(itemPeril){
	try{
		if(!isPerilOpen(itemPeril.expStat)){
			$("txtExpenseReserve").setAttribute("readOnly", "readOnly");
			$("txtExpenseReserve").readOnly = true;
			$("txtExpenseReserve").stopObserving("keyup");
			$("txtExpenseReserve").observe("click", function(){
				//showMessageBox("Loss reserve cannot be updated. \nPeril has been closed/withdrawn/denied", imgMessage.ERROR); -- robert
				showMessageBox("Expense reserve cannot be updated. \nPeril has been closed/withdrawn/denied.", "I");
			});
		}else{
			$("txtExpenseReserve").setAttribute("readOnly", "");
			$("txtExpenseReserve").readOnly = false;
			$("txtExpenseReserve").stopObserving("click");
			$("txtExpenseReserve").observe("blur", function(){
				recomputeTotalReserve($F("txtExpenseReserve"), $F("txtLossReserve"), $("txtTotalReserve"),"Y");
			});
		}
		
		if(!isPerilOpen(itemPeril.lossStat)){
			$("txtLossReserve").setAttribute("readOnly", "readOnly");
			$("txtLossReserve").stopObserving("keyup");
			$("txtLossReserve").readOnly = true;
			$("txtLossReserve").observe("click", function(){
				//showMessageBox("Expense reserve cannot be updated. \nPeril has been closed/withdrawn/denied", imgMessage.ERROR);  -- robert
				showMessageBox("Loss reserve cannot be updated. \nPeril has been closed/withdrawn/denied.", "I");
			});
		}else{
			$("txtLossReserve").setAttribute("readOnly", "");
			$("txtLossReserve").readOnly = false;
			$("txtLossReserve").stopObserving("click");
			$("txtLossReserve").observe("blur", function(){
				recomputeTotalReserve($F("txtExpenseReserve"), $F("txtLossReserve"), $("txtTotalReserve"),"Y");
			});
		}
		
	}catch(e){
		showErrorMessage("setReserveEditableProperty ", e);
	}
}