function moderateIssourceOptionsBeginning(){
	$("isscd").childElements().each(function(o){
		$$("div[name='issLine']").each(function(r){
			var issCd = r.getAttribute("issCd");//x.down("input", 2).value;
			if (o.value == issCd){
				showOption(o);
			}
		});
	});
	$("isscd").options[0].show(); $("isscd").options[0].disabled = false;
}