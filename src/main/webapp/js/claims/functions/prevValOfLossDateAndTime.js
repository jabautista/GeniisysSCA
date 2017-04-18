/**
 * Description: Retrieve pre-text value of loss date & loss time
 * @author Niknok 10.07.11
 * */
function prevValOfLossDateAndTime(){
	$("txtLossDate").value = nvl(getPreTextValue("txtLossDate"),$F("txtLossDate")); 
	$("txtLossTime").value = nvl(getPreTextValue("txtLossTime"),$F("txtLossTime")); 
	$("txtLossDate").focus();
}