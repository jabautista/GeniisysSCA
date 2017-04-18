function setRequiredFields(boolean){
	if (boolean){
		$("geogCd").addClassName("required");
		$("vesselCd").addClassName("required");
		$("cargoClassCd").addClassName("required");
		$("cargoType").addClassName("required");
	} else  {
		$("geogCd").removeClassName("required");
		$("vesselCd").removeClassName("required");
		$("cargoClassCd").removeClassName("required");
		$("cargoType").removeClassName("required");			
	}
}