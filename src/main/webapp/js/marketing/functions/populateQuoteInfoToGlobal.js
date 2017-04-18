/** Put the value of the field in global
 * @author steven
 */
function populateQuoteInfoToGlobal() {
	try {
		objMKTG.giimm001QouteInfo.address1 = $F("address1") ;
		objMKTG.giimm001QouteInfo.address2 = $F("address2") ;
		objMKTG.giimm001QouteInfo.address3 = $F("address3") ;
		objMKTG.giimm001QouteInfo.sublineCd = $("subline").getAttribute("sublinecd") == null ?  $F("subline") : $("subline").getAttribute("sublinecd");
		objMKTG.giimm001QouteInfo.creditingBranch = $F("creditingBranch") ;
		objMKTG.giimm001QouteInfo.doi = $F("doi") ;
		objMKTG.giimm001QouteInfo.doe = $F("doe") ;
		objMKTG.giimm001QouteInfo.inAccountOf = $F("inAccountOf") ;
		objMKTG.giimm001QouteInfo.acctOfCd = $F("acctOfCd");
		objMKTG.giimm001QouteInfo.remarks = $F("remarks");
	} catch (e) {
		showErrorMessage("populateQuoteInfoToGlobal",e);
	}
}