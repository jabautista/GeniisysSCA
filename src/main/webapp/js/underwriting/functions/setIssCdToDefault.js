function setIssCdToDefault(){
	var a 	= $("isscd");
	var def = $F("defaultIssCd");
	for (var x=0; x<a.length; x++){
		if (a[x].value == def){
			$("isscd").selectedIndex = x;
			$("vissCd").value = $("isscd").value;
		}
	}
}