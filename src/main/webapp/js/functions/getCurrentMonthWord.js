/**
 * Get current month
 * @author royencels 05.03.2011
 * @returns {String} - Current Month Word
 */
function getCurrentMonthWord(){
	try{
		var sysDate = new Date();
		var monthInt = sysDate.getMonth()+1;
		if(monthInt==1){		return "January";
		}else if(monthInt==2){	return "February";
		}else if(monthInt==3){	return "March";
		}else if(monthInt==4){	return "April";
		}else if(monthInt==5){	return "May";
		}else if(monthInt==6){	return "June";
		}else if(monthInt==7){	return "July";
		}else if(monthInt==8){	return "August";
		}else if(monthInt==9){	return "September";
		}else if(monthInt==10){	return "October";
		}else if(monthInt==11){	return "November";
		}else if(monthInt==12){	return "December";
		}
	} catch(e) {
		showErrorMessage("getCurrentMonthWord", e);
	}
}

objGIPIS901.currMonth = getCurrentMonthWord();