function setValidDate(){
	var acceptDate = new Date();
	var today = new Date();
	var eff = makeDate($F("validDate"));
	if (Math.ceil((eff-today)/1000/24/60/60)<30){
		showMessageBox('Validity date should be at least 30 days after system date.', imgMessage.ERROR);
		$('validDate').focus();
		$("validDate").value = objMKGlobal.preValidDate;
	}
	
	if(acceptDate != null){
		//	acceptDate 				= acceptDate.add(1).months();
		var month 				= acceptDate.getMonth()-1 < 10 ? "0" + (acceptDate.getMonth()-1) : acceptDate.getMonth()-1;
		//var month 		     = acceptDate.getMonth()+1 < 10 ? "0" + (acceptDate.getMonth()+1) : acceptDate.getMonth()+1;
		//$("acceptDate").value 	=  month + "-" + acceptDate.getDate() + "-" + acceptDate.getFullYear();	
	}
	changeTag = 1; // temp solution for the changeTag attr not covering the dates - irwin
}