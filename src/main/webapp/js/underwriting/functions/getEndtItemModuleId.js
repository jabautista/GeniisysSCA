/*
 * Created by	: Andrew
 * Date			: September 27, 2010
 * Description	: Retrieves item module id of policy with parType 'E'
 * Modified by	: mark jm
 * Date			: 10.05.2011
 * Description	: parameter lineCd is already pre-handled
 */
function getEndtItemModuleId(lineCd, menuLineCd){
	if(lineCd == "MC" || menuLineCd == "MC") {
		return endtItemModuleId.MOTOR_CAR;	
	} else if(lineCd == "FI" || menuLineCd == "FI") {
		return endtItemModuleId.FIRE;
	} else if(lineCd == "AV" || menuLineCd == "AV") {
		return endtItemModuleId.AVIATION;
	} else if(lineCd == "EN" || menuLineCd == "EN") {
		return endtItemModuleId.ENGINEERING;
	} else if(lineCd == "CA" || menuLineCd == "CA") {
		return endtItemModuleId.CASUALTY;
	} else if(lineCd == "AC" || menuLineCd == "AC") {
		return endtItemModuleId.ACCIDENT;
	} else if(lineCd == "MH" || menuLineCd == "MH") {
		return endtItemModuleId.MARINE_HULL;		
	} else if(lineCd == "MN" || menuLineCd == "MN") {
		return endtItemModuleId.CARGO;
	} 
	/*
	if(lineCd == objLineCds.MC || menuLineCd == objLineCds.MC) {
		return endtItemModuleId.MOTOR_CAR;	
	} else if(lineCd == objLineCds.FI || menuLineCd == objLineCds.FI) {
		return endtItemModuleId.FIRE;
	} else if(lineCd == objLineCds.AV || menuLineCd == objLineCds.AV) {
		return endtItemModuleId.AVIATION;
	} else if(lineCd == objLineCds.EN || menuLineCd == objLineCds.EN) {
		return endtItemModuleId.ENGINEERING;
	} else if(lineCd == objLineCds.CA || menuLineCd == objLineCds.CA) {
		return endtItemModuleId.CASUALTY;
	} else if(lineCd == objLineCds.AC || menuLineCd == objLineCds.AC) {
		return endtItemModuleId.ACCIDENT;
	} else if(lineCd == objLineCds.MH || menuLineCd == objLineCds.MH) {
		return endtItemModuleId.MARINE_HULL;		
	} else if(lineCd == objLineCds.MN || menuLineCd == objLineCds.MN) {
		return endtItemModuleId.CARGO;
	} 
	*/
}