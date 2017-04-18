// compute age
// parameter: date = birthdate
function computeAge(date) {
	if(date.length <= 1){ // rencela
		return 0;
	}
	
	var bday = date.substr(3, 2);
	if(bday.substr(0, 1)=='0') {
		bday = bday.substr(4, 2);
	}
	
	var bmo = date.substr(0, 2);
	if(bmo.substr(0, 1)=='0') {
		bmo = bmo.substr(1, 2);
	}
	
	var byr = date.substr(6, 4);
	
	var now = new Date();
	tday = now.getDate();
	tmo = (now.getMonth()+1);
	tyr = (now.getFullYear());
	
	var age = 0;
	if((tmo > bmo) || (tmo == bmo && tday >= bday)) {
		age = byr;
	} else {
		age = parseInt(byr) + 1;
	}

	var ageNow = tyr-age;
	if(ageNow <= 0) {
		if(theTargetAge!=null) {
			theTargetAge.value="0";
		}
	} else {
		if(theTargetAge != null) {
			theTargetAge.value=ageNow+1;
		}
	}
	if (ageNow < 0) {
		showMessageBox("Date of birth should not be later than system date.", imgMessage.ERROR);
		return 0;
	} else {
		hideNotice();
		return ageNow;
	}
}