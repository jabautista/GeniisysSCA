function setItemPerilGrouped(newObj){
	try{
		var itemPerilGrouped = new Object();
		
		itemPerilGrouped.parId				= objUWParList.parId;
		itemPerilGrouped.itemNo				= $F("itemNo");
		itemPerilGrouped.groupedItemNo		= $F("groupedItemNo") == "" ? null : removeLeadingZero($F("groupedItemNo"));
		itemPerilGrouped.groupedItemTitle	= changeSingleAndDoubleQuotes2($F("groupedItemTitle"));
		itemPerilGrouped.lineCd				= objUWGlobal.lineCd;
		itemPerilGrouped.perilCd			= $F("cPerilCd");
		itemPerilGrouped.perilName			= $F("cPerilName"); // andrew - 1.10.2012 //$("cPerilCd").options[$("cPerilCd").selectedIndex].text;
		itemPerilGrouped.recFlag			= nvl($F("cRecFlag"), "A");
		itemPerilGrouped.noOfDays			= $F("cNoOfDays");
		itemPerilGrouped.premRt				= $F("cPremRt");
		itemPerilGrouped.tsiAmt				= unformatCurrencyValue($F("cTsiAmt"));
		itemPerilGrouped.premAmt			= unformatCurrencyValue($F("cPremAmt"));
		itemPerilGrouped.annTsiAmt			= unformatCurrencyValue($F("cAnnTsiAmt"));
		itemPerilGrouped.annPremAmt			= unformatCurrencyValue($F("cAnnPremAmt"));
		itemPerilGrouped.aggregateSw		= $("cAggregateSw").checked ? "Y" : "N";
		itemPerilGrouped.baseAmt			= unformatCurrencyValue($F("cBaseAmt"));
		itemPerilGrouped.riCommRate			= $F("cRiCommRt");
		itemPerilGrouped.riCommAmt			= unformatCurrencyValue($F("cRiCommAmt"));
		itemPerilGrouped.wcSw				= $F("cWcSw"); // andrew - 01.12.2012
		itemPerilGrouped.perilType			= $F("cPerilType"); // irwin 7.19.2012
		itemPerilGrouped.origAnnPremAmt		= unformatCurrencyValue($("annPremCopy").value);
		if(newObj == null){
			return itemPerilGrouped;
		}else{
			newObj.gipiWItmperlGrouped = itemPerilGrouped;
		}
	}catch(e){
		showErrorMessage("setItemPerilGrouped", e);
	}
}