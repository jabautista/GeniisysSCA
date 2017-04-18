function checkLineCdIssCdMatch(lineCd, issCd){
	var result = false;
	$$("div[name='issLine']").each(function(r){
		var line = r.getAttribute("lineCd"); //r.down("input", 0).value;
		var iss = r.getAttribute("issCd");//r.down("input", 2).value;
		if ((line == lineCd) && (iss == issCd)){
			result = true;
		}
	});
	return result;
}