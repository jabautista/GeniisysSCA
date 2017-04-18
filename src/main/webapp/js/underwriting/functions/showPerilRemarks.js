/**
 * @author rey
 * @date 08.10.2011
 * @param obj
 */
function showPerilRemarks(obj){
	$("remarksPeril").value      = (obj == null ? "" : unescapeHTML2(nvl(obj.remarks, "")));
}