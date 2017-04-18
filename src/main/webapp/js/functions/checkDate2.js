/**
 * Validates the manual date input
 * @param MM-DD-YYYY Format
 * @param MM/DD/YYYY Format
 * @return boolean
 */
function checkDate2(value){
	//var reLong = /\b\d{1,2}[\/-]\d{1,2}[\/-]\d{4}\b/;
	//var reLong = /\b\d{1,2}[-]\d{1,2}[-]\d{4}\b/; //replaced by john 11.26.2014 block manual entry of date in MM/DD/YYYY Format
	var reLong = /^\d{1,2}[-]\d{1,2}[-]\d{4}$/; //Modified by Jerome Bautista 01.05.2016 SR 3467 - Checks for special characters at the end of the entered date.
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
		            	showMessageBox("Invalid year.", imgMessage.INFO);
		            	return false;
		            }
		        } else {
		        	showMessageBox("Invalid month.", imgMessage.INFO);
		        	return false;
		        }
		    } else {
		    	showMessageBox("Invalid date.", imgMessage.INFO);
		    	return false;
		    }
	}else{
		showMessageBox("Date must be entered in a format like MM-DD-YYYY.", imgMessage.INFO);
		return false;
	}
}