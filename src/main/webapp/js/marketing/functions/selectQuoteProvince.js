/**
 * Function executed when a province record in lov is selected
 * @author andrew
 * @date   04.20.2011
 */
function selectQuoteProvince(row){
	if(row.provinceCd != $F("provinceCd")){// emsy 12.02.2011 ~ added this
		$("provinceCd").value	= row.provinceCd;
		$("province").value		= row.provinceDesc;
		$("cityCd").value 		= "";
		$("city").value			= "";
		$("district").value 	= "";
		$("districtNo").value 	= "";
		$("block").value 		= "";
		$("blockId").value 		= "";
		$("eqZone").value 		= "";
		$("typhoonZone").value 	= "";
		$("floodZone").value 	= "";
	
		fireEvent($("block"), "change");
	}
}