/** Put the value of the global in the field
 * @author steven
 */
function populateQuoteInfo() {
	try {
		$("address1").value = objMKTG.giimm001QouteInfo.address1;
		$("address2").value = objMKTG.giimm001QouteInfo.address2;
		$("address3").value = objMKTG.giimm001QouteInfo.address3;
		$("subline").value = objMKTG.giimm001QouteInfo.sublineCd;
		$("creditingBranch").value = objMKTG.giimm001QouteInfo.creditingBranch;
		$("doi").value = objMKTG.giimm001QouteInfo.doi;
		$("doe").value = objMKTG.giimm001QouteInfo.doe;
		$("inAccountOf").value = objMKTG.giimm001QouteInfo.inAccountOf;
		$("acctOfCd").value = objMKTG.giimm001QouteInfo.acctOfCd;
		$("remarks").value = objMKTG.giimm001QouteInfo.remarks;
		objMKTG.giimm001QouteInfo = {};
		changeTag = 1;
	} catch (e) {
		showErrorMessage("populateQuoteInfo",e);
	}
}