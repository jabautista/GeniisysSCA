/*
 * Created by	: Andrew
 * Date			: September 27, 2010
 * Description	: Retrieves item module id
 * Parameters	: parType - type of the policy
 * 				  lineCd - Line code of the policy
 */
function getItemModuleId(parType, lineCd, menuLineCd) {
	var moduleId = null;
	if("P" == parType) {
		moduleId = getPolItemModuleId(lineCd, menuLineCd);
	} else if ("E" == parType) {
		moduleId = getEndtItemModuleId(lineCd, menuLineCd);
	}
	return moduleId;
}