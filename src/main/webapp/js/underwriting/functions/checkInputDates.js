function checkInputDates(currentFieldId, fromDateId, toDateId){
	if ($F(fromDateId) != "" && $F(toDateId) != ""){
		if(compareDatesIgnoreTime(Date.parse($F(fromDateId)), Date.parse($F(toDateId))) == -1){
			$(currentFieldId).value = "";
			showWaitingMessageBox("From Date should not be later than To Date.", "I", 
					function(){
						$(currentFieldId).focus();
					}
				);
		}
	}
}