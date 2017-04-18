function populateSlNameDtls(obj) {
	$("ucSlName").update('<option value="" slCode="" slName=""></option>');
	var options = "";
	for ( var i = 0; i < obj.length; i++) {
		options += '<option value="' + obj[i].slCd + '" slCode="' + obj[i].slCd
				+ '" slName="' + obj[i].slName + '">' + obj[i].slName
				+ '</option>';
	}
	// obj[i].rvLowValue
	$("ucSlName").insert({
		bottom : options
	});
	$("ucSlName").selectedIndex = 0;
}