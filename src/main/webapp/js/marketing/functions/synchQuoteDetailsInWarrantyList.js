/**
 * Populates the value from the list (same with synchDetailsWarrantyList, just edited ids)
 * @author emsy bolaños
 * @date 11.16.2011
 */
function synchQuoteDetailsInWarrantyList(row) {
	$("hidWcCd").value = row.wcCd;
	$("warratyTitleDisplay").value = row.wcTitle;
	$("warrantyClauseType").value 	= row.wcSw;
	$("warrantyText").value = unescapeHTML2(row.wcText);

	/*$("inputWarrantyText").innerHTML = unescapeHTML2(nvl(row.wcText1,"")+nvl(row.wcText2,"")+nvl(row.wcText3,"")+nvl(row.wcText4,"")+nvl(row.wcText5,"")+
													nvl(row.wcText6,"")+nvl(row.wcText7,"")+nvl(row.wcText8,"")+nvl(row.wcText9,"")+nvl(row.wcText10,"")+
													nvl(row.wcText11,"")+nvl(row.wcText12,"")+nvl(row.wcText13,"")+nvl(row.wcText14,"")+nvl(row.wcText15,"")+ 
													nvl(row.wcText16,"")+nvl(row.wcText17,""));*/
	$("hidOrigWarrantyText").value = $F("warrantyText");
	$("printSwitch").checked 	= row.printSw == 'Y' ? true : false;
	$("changeTag").checked 	= row.changeTag == 'Y' ? true : false;	
	var max = 0;
	$$("div[name='row']").each(function (row) {
		if (parseInt(row.down("input", 4).value) > max) {
			max = parseInt(row.down("input", 4).value);
		}
	});
	$("printSeqNumber").value = max+1;	
	$("warrantyText").setAttribute("changed", "changed");
	changeTag = 1; 
}