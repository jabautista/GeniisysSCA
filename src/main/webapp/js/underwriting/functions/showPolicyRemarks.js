/**
 * @author rey
 * @date 08.10.2011
 * @param object
 */
function showPolicyRemarks(obj){
	$("remarksPolicy").value      = (obj == null ? "" : unescapeHTML2(nvl(obj.remarks, "")));
}