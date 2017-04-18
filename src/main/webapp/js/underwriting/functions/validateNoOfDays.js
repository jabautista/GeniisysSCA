/*	Created by	: mark jm 07.28.2011
 * 	Moved from	: peril information page
 */
function validateNoOfDays(){
	try {
		var noOfDays = nvl($F("perilNoOfDays").replace(/,/g , ""), 0);
		var baseAmt = nvl($F("perilBaseAmt").replace(/,/g , ""), 0);
		if ("none" != document.getElementById("accPerilDetailsDiv").style.display){
			if ("Y" == $F("perilGroupExists")){
				clearItemPerilFields();
				showMessageBox("There are existing grouped item perils and you cannot modify, add or delete perils in current item.", "info");
			} else if (isNaN(noOfDays) || (noOfDays.include("."))){//handling non-numerical or decimal values
				$("perilNoOfDays").focus();
				$("perilNoOfDays").value = "";
				showMessageBox("Entered No. of Days is invalid. Valid value is from 0 to 99,999.", imgMessage.ERROR);
			} else if ((parseFloat(noOfDays) < 0) || (parseFloat(noOfDays) > 99999)){
				$("perilNoOfDays").focus();
				$("perilNoOfDays").value = "";
				showMessageBox("Entered No. of Days is invalid. Valid value is from 0 to 99,999.", imgMessage.ERROR);
			} else {
				//if ((noOfDays != 0) && (baseAmt != 0)){ condition replaced by: Nica 04.22.2013
				if ((noOfDays != 0) || (baseAmt != 0)){
					$("perilTsiAmt").value = noOfDays * baseAmt;
					getPostTextTsiAmtDetails();
				}
				$("perilNoOfDays").value = parseFloat(noOfDays);
			} 
		}
	}catch (e){
		showErrorMessage("validateNoOfDays",e);
	}
}