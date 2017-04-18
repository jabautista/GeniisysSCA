function checkRequiredSelect(){
	var selects = $$("select");
	for (var i=0; i<selects.length; i++) {
		var obj = selects[i];
		if(!(obj.value == "0" || obj.value == "")){
			if(obj.firstDescendant().value== "0" || obj.firstDescendant().value == ""){
				obj.firstDescendant().remove();
			}
		}
	}
}