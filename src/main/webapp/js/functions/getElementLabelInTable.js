/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	11.25.2011	mark jm			get the corresponding label of a particular field 
 */
function getElementLabelInTable(id){
	try{
		var lbl = "";
		
		for(var i=0, length=$$('td[for]').length; i<length; i++){
			if(id == $$('td[for]')[i].getAttribute("for")){
				lbl = $$('td[for]')[i].innerHTML;
				break;
			}
		}
		
		return lbl;
	}catch(e){
		showErrorMessage("getElementLabelInTable", e);
	}
}