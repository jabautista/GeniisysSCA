/*	Created by	: Bryan Joseph G. Abuluyan 12.10.2010
 * 	Description	: sets classname "required" to certain fields when chosen record has a recFlag of "A" or if no record is chosen
 * 	Parameters	: 
 */
function setRecFlagDependentFields(){
	if ("A" == nvl($F("recFlag"), "A")){
		$("vesselCd").addClassName("required");
		$("geogLimit").addClassName("required");
	} else {
		$("vesselCd").removeClassName("required");
		$("geogLimit").removeClassName("required");
	}
}