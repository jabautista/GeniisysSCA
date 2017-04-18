/**
 * Validates the manual date input
 * @author Irwin Tabisora
 * @param MM-DD-YYYY Format
 * @param MM/DD/YYYY Format
 * @return boolean
 */
function checkDate(dateField){
	var inputDate = $(dateField);
	var reLong = /\b\d{1,2}[\/-]\d{1,2}[\/-]\d{4}\b/;
   // var reShort = /\b\d{1,2}[\/-]\d{1,2}[\/-]\d{2}\b/;
	var returnval=false;
	
	if (reLong.test(inputDate.value) /*|| reShort.test(inputDate.value)*/){
		var delimChar = (inputDate.value.indexOf("/") != -1) ? "/" : "-";
		var monthfield=inputDate.value.split(delimChar)[0];
		var dayfield=inputDate.value.split(delimChar)[1];
		var yearfield=inputDate.value.split(delimChar)[2];
		//var dayobj = new Date(yearfield, monthfield-1, dayfield);
		var testDate = new Date(yearfield, monthfield-1, dayfield);
			if (testDate.getDate() == dayfield) {
	        	if (testDate.getMonth() + 1 == monthfield) {
					if (testDate.getFullYear() == yearfield) {
		                // fill field with database-friendly format
		                inputDate.value = monthfield + "-" + dayfield + "-" + yearfield;
		                return true;
		            } else {
		            	//$(dateField).focus();
		            	//$(dateField).select();
		            	inputDate.value = "";
		            	showMessageBox("Invalid year.", imgMessage.INFO);
		            }
		        } else {
		        	//inputDate.focus();
		        	//inputDate.select();
		        	inputDate.value = "";
		        	showMessageBox("Invalid month.", imgMessage.INFO);
		        }
		    } else {
		    	//inputDate.focus();
		    	//inputDate.select();
		    	inputDate.value = "";
		    	showMessageBox("Invalid date.", imgMessage.INFO);
		    }
	}else{
		//inputDate.focus();
		//inputDate.select();
		inputDate.value = "";
		showMessageBox("Invalid Date Format.", imgMessage.INFO);
		return false;
	}
}