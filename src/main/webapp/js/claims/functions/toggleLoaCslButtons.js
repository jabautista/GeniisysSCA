function toggleLoaCslButtons(){
	try{
		if(tempArrForPrint.length == 0){
			disableButton("btnPrintLoaOrCsl");
		}else{
			enableButton("btnPrintLoaOrCsl");
		}
		if(tempArrForGenerate.length == 0){
			disableButton("btnGenerate");
		}else{
			enableButton("btnGenerate");
		}
	}catch(e){
		showErrorMessage("toggleLoaCslButtons",e);
	}
}