/*
 * Created by	: Andrew
 * Date			: September 28, 2010
 * Description	: Retrieves quotation item module id 
 * Parameters	: lineCd - Line code of the policy
 */
function getQuoteItemModuleId(lineCd){
	switch(lineCd){
		case "MC": return quoteItemModuleId.MOTOR_CAR;
		case "FI": return quoteItemModuleId.FIRE;
		case "AV": return quoteItemModuleId.AVIATION;
		case "EN": return quoteItemModuleId.ENGINEERING;
		case "CA": return quoteItemModuleId.CASUALTY;
		case "AH": return quoteItemModuleId.ACCIDENT;
		case "MH": return quoteItemModuleId.MARINE_HULL;
		case "MN": return quoteItemModuleId.CARGO;
	}
}