function moderateIssourceOptionsByLine(){
	var line = $("linecd").value;
	if ("" != line){
		$("isscd").childElements().each(function(o){
			$$("div[name='issLine']").each(function(r){
				var issCd 	= r.getAttribute("issCd");//x.down("input", 2).value;
				if (line == r.getAttribute("lineCd")/*r.down("input", 0).value*/){
					if (o.value == issCd){
						//o.show();
						showOption(o);
					}
				}
			});
		});
	} else {
		hideAllIssourceOptions();
		moderateIssourceOptionsBeginning();
		setIssCdToDefault();
	}
	$("isscd").options[0].show();
	showOption($("isscd").options[0]);
}