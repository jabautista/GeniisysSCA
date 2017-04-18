/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	11.25.2011	mark jm			compose the error message for display (for number fields) 
 *  10.4.2012   Irwin           Added custom label
 */
function getNumberFieldErrMsg(m, addSeparator, useCustomLabel){
	try{
		var mssg = "";
		if(m.up(1).down(0) != null && m.up(1).down(0) != undefined){
			//mssg = "Invalid " + m.up(1).down(0).innerHTML.trim() + ". Valid value is from ";
			mssg = "Invalid " + (nvl(useCustomLabel,"N") == "Y" ? m.getAttribute("customLabel") : getElementLabelInTable(m.id).trim()) + ". Valid value should be from ";
			mssg = mssg + (addSeparator ? addSeparatorToNumber2(m.getAttribute("min"), ",") : m.getAttribute("min")) + " to " + (addSeparator ? addSeparatorToNumber2(m.getAttribute("max"), ",") : m.getAttribute("max")) + ".";
		}		
		
		return mssg;		
	}catch(e){
		showErrorMessage("getNumberFieldErrMsg", e);
	}
}