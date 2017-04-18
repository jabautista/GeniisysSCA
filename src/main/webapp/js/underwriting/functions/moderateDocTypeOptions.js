function moderateDocTypeOptions(){
	$("docType").childElements().each(function(o){
		$$("div[name='forPrint']").each(function(dt){
			if (dt.getAttribute("docType") == o.value){
				//o.hide();
				hideOption(o);
			}
		});
	});
}