/*	Created by	: mark jm 03.02.2011
 * 	Description	: format date fields in GIPIWPolbas
 */
function formatGIPIWPolbasDateColumns(){
	try{
		objGIPIWPolbas.inceptDate 		= objGIPIWPolbas.inceptDate == null ? null : dateFormat(objGIPIWPolbas.inceptDate, "mm-dd-yyyy HH:MM:ss");
		//objGIPIWPolbas.inceptDate 		= objGIPIWPolbas.inceptDate == null ? null : dateFormat(objGIPIWPolbas.inceptDate, "mm-dd-yyyy HH:MM:ss");
		objGIPIWPolbas.effDate 			= objGIPIWPolbas.effDate == null ? null : dateFormat(objGIPIWPolbas.effDate, "mm-dd-yyyy HH:MM:ss");
		objGIPIWPolbas.expiryDate 		= objGIPIWPolbas.expiryDate == null ? null : dateFormat(objGIPIWPolbas.expiryDate, "mm-dd-yyyy HH:MM:ss");
		objGIPIWPolbas.endtExpiryDate 	= objGIPIWPolbas.endtExpiryDate == null ? null : dateFormat(objGIPIWPolbas.endtExpiryDate, "mm-dd-yyyy HH:MM:ss");
		objGIPIWPolbas.issueDate 		= objGIPIWPolbas.issueDate == null ? null : dateFormat(objGIPIWPolbas.issueDate, "mm-dd-yyyy HH:MM:ss");
	}catch(e){
		showErrorMessage("formatGIPIWPolbasDateColumns", e);
	}	
}