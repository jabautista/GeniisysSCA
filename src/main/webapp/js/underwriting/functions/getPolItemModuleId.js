/*
 * Created by	: Andrew
 * Date			: September 27, 2010
 * Description	: Retrieves item module id of policy with parType 'P'
 * Modified by	: mark jm
 * Date			: 10.05.2011
 * Description	: parameter lineCd is already pre-handled
 */
function getPolItemModuleId(lineCd, menuLineCd){
	if(lineCd == "MC" || menuLineCd == "MC") {
		return parItemModuleId.MOTOR_CAR;	
	} else if(lineCd == "FI" || menuLineCd == "FI") {
		return parItemModuleId.FIRE;
	} else if(lineCd == "AV" || menuLineCd == "AV") {
		return parItemModuleId.AVIATION;
	} else if(lineCd == "EN" || menuLineCd == "EN") {
		return parItemModuleId.ENGINEERING;
	} else if(lineCd == "CA" || menuLineCd == "CA") {
		return parItemModuleId.CASUALTY;
	} else if(lineCd == "AC" || menuLineCd == "AC") {
		return parItemModuleId.ACCIDENT;
	} else if(lineCd == "MH" || menuLineCd == "MH") {
		return parItemModuleId.MARINE_HULL;		
	} else if(lineCd == "MN" || menuLineCd == "MN") {
		return parItemModuleId.CARGO;
	} 
	/*
	if(lineCd == objLineCds.MC || menuLineCd == objLineCds.MC) {
		return parItemModuleId.MOTOR_CAR;	
	} else if(lineCd == objLineCds.FI || menuLineCd == objLineCds.FI) {
		return parItemModuleId.FIRE;
	} else if(lineCd == objLineCds.AV || menuLineCd == objLineCds.AV) {
		return parItemModuleId.AVIATION;
	} else if(lineCd == objLineCds.EN || menuLineCd == objLineCds.EN) {
		return parItemModuleId.ENGINEERING;
	} else if(lineCd == objLineCds.CA || menuLineCd == objLineCds.CA) {
		return parItemModuleId.CASUALTY;
	} else if(lineCd == objLineCds.AC || menuLineCd == objLineCds.AC) {
		return parItemModuleId.ACCIDENT;
	} else if(lineCd == objLineCds.MH || menuLineCd == objLineCds.MH) {
		return parItemModuleId.MARINE_HULL;		
	} else if(lineCd == objLineCds.MN || menuLineCd == objLineCds.MN) {
		return parItemModuleId.CARGO;
	}
	*/
}