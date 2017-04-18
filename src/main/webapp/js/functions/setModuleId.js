/* Modified by : Tonio January 21, 2011 set attribute moduledId needed for Bill Premiums
 * Created by	: Andrew
 * Date			: October 4, 2010
 * Description	: Shows the id of module
 * Parameter	: moduleId - id of module to show 
 */
function setModuleId(moduleId){
	if (moduleId == null || moduleId == ""){
		$("lblModuleId").update("");
		$("lblModuleId").setAttribute("moduleId", "");
	} else {
		$("lblModuleId").update("Module Id: " + moduleId);
		$("lblModuleId").setAttribute("moduleId", moduleId);
	}
}