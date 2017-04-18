function synchDetailsInWarrantyList(row, generatedPrintSeqNo) {
	$("hidWcCd").value = row.wcCd == null ? "" : unescapeHTML2(row.wcCd);
	$("txtWarrantyTitle").value = row.wcTitle == null ? "" : unescapeHTML2(row.wcTitle);
	$("inputWarrantyType").value = row.wcSw == null ? "" : unescapeHTML2(row.wcSw);
	$("inputWarrantyText").value = row.wcText == null ? "" : unescapeHTML2(row.wcText);
	
	/*
	 * $("inputWarrantyText").innerHTML =
	 * unescapeHTML2(nvl(row.wcText1,"")+nvl(row.wcText2,"")+nvl(row.wcText3,"")+nvl(row.wcText4,"")+nvl(row.wcText5,"")+
	 * nvl(row.wcText6,"")+nvl(row.wcText7,"")+nvl(row.wcText8,"")+nvl(row.wcText9,"")+nvl(row.wcText10,"")+
	 * nvl(row.wcText11,"")+nvl(row.wcText12,"")+nvl(row.wcText13,"")+nvl(row.wcText14,"")+nvl(row.wcText15,"")+
	 * nvl(row.wcText16,"")+nvl(row.wcText17,""));
	 */
	$("hidOrigWarrantyText").value = $F("inputWarrantyText");
	$("inputPrintSwitch").checked = row.printSw == 'Y' ? true : false;
	$("inputChangeTag").checked = row.changeTag == 'Y' ? true : false;
	// var max = 0;
	/*
	 * $$("div[name='row']").each(function (row) { if
	 * (parseInt(row.down("input", 4).value) > max) { max =
	 * parseInt(row.down("input", 4).value); } });
	 */// replaced by: Nica 11.23.2011
	// $$("div[name='wcRow']").each(function (row) {
	// if (parseInt(nvl(row.getAttribute("printSeqNo"), 0)) > max) {
	// max = parseInt(row.getAttribute("printSeqNo"));
	// }
	// }); // remove by steven 4.30.2012
	$("inputPrintSeqNo").value = generatedPrintSeqNo;
	$("txtWarrantyTitle").setAttribute("changed", "changed");
}