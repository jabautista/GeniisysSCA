/**
 * Function executed when a province record in lov is selected
 * 
 * @author andrew
 * @date 04.20.2011
 */
function selectProvince(row) {
	if (row.provinceCd != $F("provinceCd")) {
		$("region").value = row.regionCd;
		$("provinceCd").value = unescapeHTML2(row.provinceCd); // edited by Gab Ramos 07.15.15
		$("province").value = unescapeHTML2(row.provinceDesc);
		$("cityCd").value = "";
		$("city").value = "";
		$("district").value = "";
		$("districtNo").value = "";
		$("block").value = "";
		$("blockId").value = "";
		$("eqZone").value = "";
		$("typhoonZone").value = "";
		$("floodZone").value = "";

		fireEvent($("block"), "change");
	}
}