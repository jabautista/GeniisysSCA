function moderateLineOptionsByIssource(){
	var issCd = $("isscd").value;
	$("linecd").childElements().each(function(o){
		$$("div[name='issLine']").each(function(r){
			var lineCd 	= r.getAttribute("lineCd");//r.down("input", 0).value;
			if (issCd == r.getAttribute("issCd")/*down("input", 2).value*/){
				if (o.value == lineCd){
					o.show(); o.disabled = false;
				}
			}
		});
	});
	//$("linecd").options[0].show();
	//$("linecd").options[0].disabled = false;
}