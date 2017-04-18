/*	Created by	: mark jm 07.29.2011
 * 	Description	: return new itemperil object
 */
function createItemPeril(){
	try {
		var objPeril = new Object();
		
		objPeril.parId 			= (objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId"));
		objPeril.itemNo 		= $F("itemNo");
		objPeril.lineCd 		= (objUWGlobal.packParId != null ? objCurrPackPar.lineCd : $F("globalLineCd"));
		objPeril.perilCd 		= $("perilCd").value;
		objPeril.perilName 		= escapeHTML2($F("txtPerilName"));	//$F("btnAddItemPeril") == "Update" ? escapeHTML2($F("txtPerilName")) : escapeHTML2($("perilCd").options[$("perilCd").selectedIndex].getAttribute("perilName"));
		objPeril.perilType 		= $F("perilType");
		objPeril.tarfCd 		= $F("perilTarfCd");
		objPeril.premRt 		= $F("perilRate") == "" ? null : formatToNineDecimal($F("perilRate"));
		objPeril.tsiAmt 		= $F("perilTsiAmt") == "" ? null : $F("perilTsiAmt").replace(/,/g , "");
		objPeril.premAmt 		= $F("premiumAmt") == "" ? null : $F("premiumAmt").replace(/,/g , "");
		objPeril.annTsiAmt 		= $F("perilTsiAmt") == "" ? null : $F("perilTsiAmt").replace(/,/g , "");
		//objPeril.annPremAmt 	= $F("premiumAmt") == "" ? null : $F("premiumAmt").replace(/,/g , "");
		objPeril.annPremAmt 	= computePerilAnnPremAmount(objPeril.tsiAmt, objPeril.premRt); // andrew - 07.25.2012 - call the computePerilAnnPremAmount function, to handle prorate and short rate issue
		objPeril.recFlag 		= "";
		objPeril.compRem 		= escapeHTML2(objUWParList.issCd == "RI" ? $F("compRemRi") : $F("compRem"));
		objPeril.discountSw		= $("chkDiscountSw").checked == true ? "Y" : "N";
		objPeril.prtFlag 		= $F("perilPrtFlag");
		objPeril.riCommRate 	= nvl($F("perilRiCommRate"), null);
		objPeril.riCommAmt 		= nvl($F("perilRiCommAmt").replace(/,/g , ""), null); // added replace function if perilRiCommAmt has currency format (emman 05.17.2011)
		objPeril.asChargeSw 	= "";
		objPeril.surchargeSw 	= $("chkSurchargeSw").checked == true ? "Y" : "N";
		objPeril.noOfDays 		= nvl($F("perilNoOfDays"), null);
		objPeril.baseAmt 		= nvl($F("perilBaseAmt").replace(/,/g , ""), null);
		objPeril.aggregateSw 	= $("chkAggregateSw").checked == true ? "Y" : "N";
		objPeril.bascPerlCd 	= nvl($F("bascPerlCd"), null);
		
		return objPeril;
	} catch(e){
		showErrorMessage("createObjFromCurrPeril", e);
	}
}