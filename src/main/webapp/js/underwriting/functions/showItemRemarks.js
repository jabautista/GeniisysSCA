/**
 * @author rey
 * @date 08.10.2011
 * @param obj
 */
function showItemRemarks(obj){
	$("remarksItem").value      = (obj == null ? "" : unescapeHTML2(nvl(obj.remarks, "")));
}