function populateLeadPolicyCommInvPerilNameFields(obj){
	$("invCommPerilDesc").value = obj== null ? "" : unescapeHTML2(nvl(obj.perilName, ""));
	$("invCommPerilDesc2").value = obj== null ? "" : unescapeHTML2(nvl(obj.perilName, ""));
}