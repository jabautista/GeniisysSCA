function makeFireAIObject(){
	var gipiQuoteFireItm = new Object();
	var quoteId = objMKGlobal.packQuoteId != null ? objCurrPackQuote.quoteId : objGIPIQuote.quoteId; // modified by: nica 06.13.2011 to be reused by package quotation
	
	gipiQuoteFireItm.quoteId 				= quoteId; 
	gipiQuoteFireItm.itemNo 				= $F("txtItemNo");
	gipiQuoteFireItm.assignee 				= escapeHTML2($F("assignee"));
	gipiQuoteFireItm.eqZone					= $F("eqZone");
	gipiQuoteFireItm.eqDesc					= $F("eqZoneDesc");
	gipiQuoteFireItm.frItemType				= $F("frItemType");
	gipiQuoteFireItm.typhoonZone			= $F("typhoonZone");
	gipiQuoteFireItm.typhoonZoneDesc		= $F("typhoonZoneDesc");
	gipiQuoteFireItm.provinceCd				= $F("provinceCd");
	gipiQuoteFireItm.provinceDesc			= $F("province");
	gipiQuoteFireItm.floodZone				= $F("floodZone");
	gipiQuoteFireItm.floodZoneDesc			= $F("floodZoneDesc");
	gipiQuoteFireItm.locRisk1				= escapeHTML2($F("locRisk1"));
	gipiQuoteFireItm.cityCd					= $F("cityCd");
	gipiQuoteFireItm.city					= $F("city");
	gipiQuoteFireItm.tariffZone				= $F("tariffZone");
	gipiQuoteFireItm.locRisk2				= escapeHTML2($F("locRisk2"));
	gipiQuoteFireItm.districtNo				= $F("districtNo");
	gipiQuoteFireItm.district				= $F("district");
	gipiQuoteFireItm.tarfCd					= $F("tarfCd");
	gipiQuoteFireItm.locRisk3				= escapeHTML2($F("locRisk3"));
	gipiQuoteFireItm.blockId				= $F("blockId");
	gipiQuoteFireItm.constructionCd			= $F("construction");
	gipiQuoteFireItm.front					= escapeHTML2($F("front"));
	gipiQuoteFireItm.riskCd					= $F("riskCd");//($F("risk").split("_"))[1];
	gipiQuoteFireItm.riskDesc				= escapeHTML2($F("risk"));
	gipiQuoteFireItm.constructionRemarks	= escapeHTML2($F("constructionRemarks"));
	gipiQuoteFireItm.right					= escapeHTML2($F("right"));
	gipiQuoteFireItm.occupancyCd			= $F("occupancyCd");
	gipiQuoteFireItm.occupancyDesc			= $F("occupancy");
	gipiQuoteFireItm.occupancyRemarks		= escapeHTML2($F("occupancyRemarks"));
	gipiQuoteFireItm.left					= escapeHTML2($F("left"));
	gipiQuoteFireItm.rear					= escapeHTML2($F("rear"));
	gipiQuoteFireItm.blockNo				= $F("block");//$("block").options[$("block").selectedIndex].getAttribute("blockNo");
	gipiQuoteFireItm.dateFrom				= $F("fromDate");
	gipiQuoteFireItm.dateTo					= $F("toDate"); //last two fields added by angelo
	
	// next 3 added by roy
	gipiQuoteFireItm.eqZoneDesc				= $F("eqZoneDesc");
	gipiQuoteFireItm.typhoonZoneDesc		= $F("typhoonZoneDesc");
	gipiQuoteFireItm.floodZoneDesc			= $F("floodZoneDesc");
    /*Added by MarkS 02/08/2017 SR5918*/
	gipiQuoteFireItm.latitude		= escapeHTML2($F("latitude"));
	gipiQuoteFireItm.longitude		= escapeHTML2($F("longitude"));
	return gipiQuoteFireItm;
}