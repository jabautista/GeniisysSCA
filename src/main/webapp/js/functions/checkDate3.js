/**
 * Validates the manual TIME input and focuses on the element if the error is triggered
 * @author Irwin Tabisora
 * @param HH:MM:SS AM/PM format.
 * @param elemName 
 * @return boolean
 */
function checkDate3(value, elemName){
	try{
		var reLong = /\b\d{1,2}[\/-]\d{1,2}[\/-]\d{4}\b/;
		   // var reShort = /\b\d{1,2}[\/-]\d{1,2}[\/-]\d{2}\b/;
		var returnval=false;
		
		if (reLong.test(value) /*|| reShort.test(inputDate.value)*/){
			var delimChar = (value.indexOf("/") != -1) ? "/" : "-";
			var monthfield=value.split(delimChar)[0];
			var dayfield=value.split(delimChar)[1];
			var yearfield=value.split(delimChar)[2];
			var testDate = new Date(yearfield, monthfield-1, dayfield);
				if (testDate.getDate() == dayfield) {
		        	if (testDate.getMonth() + 1 == monthfield) {
						if (testDate.getFullYear() == yearfield) {
			                return true;
			            } else {
			            	customShowMessageBox("Invalid year.", imgMessage.INFO,elemName);
			            	return false;
			            }
			        } else {
			        	customShowMessageBox("Invalid month.", imgMessage.INFO,elemName);
			        	return false;
			        }
			    } else {
			    	customShowMessageBox("Invalid date.", imgMessage.INFO,elemName);
			    	return false;
			    }
		}else{
			customShowMessageBox("Date must be entered in a format like MM-DD-YYYY.", imgMessage.INFO,elemName);
			return false;
		}	
	}catch(e){
		showErrorMessage("checkDate3", e);
	}
	
}