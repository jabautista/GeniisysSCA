/**
 * causes delay
 * @param millis
 * @return
 */
function pauseJs(millis){	
	var date = new Date();
	var curDate = null;
	do{
		curDate = new Date(); 
	}while(curDate-date < millis);
}