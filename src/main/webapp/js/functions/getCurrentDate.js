/**
 * 
 * @author niknok 10.26.2011
 * @returns {String} - Current date in MM-dd-yyyy format
 */
function getCurrentDate(){
	try{
		var sysDate = new Date();
		return formatNumberDigits((sysDate.getMonth()+1),2)+"-"+formatNumberDigits(sysDate.getDate(),2)+"-"+sysDate.getFullYear();
	} catch(e) {
		showErrorMessage("getCurrentDate", e);
	}
}