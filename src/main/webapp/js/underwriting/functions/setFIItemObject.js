function setFIItemObject(newObj){
	try{
		var gipiWFireItm = new Object();
		
		gipiWFireItm.assignee 				= escapeHTML2($F("assignee"));
		gipiWFireItm.eqZone					= $F("eqZone");
		gipiWFireItm.eqDesc					= escapeHTML2($F("eqZoneDesc"));
		gipiWFireItm.frItemType				= $F("frItemType");		
		gipiWFireItm.typhoonZone			= $F("typhoonZone");
		gipiWFireItm.typhoonZoneDesc		= escapeHTML2($F("typhoonZoneDesc"));
		gipiWFireItm.provinceCd				= escapeHTML2($F("provinceCd")); //Gzelle 05282015 SR4302
		gipiWFireItm.provinceDesc			= escapeHTML2($F("province"));	//Gzelle 05282015 SR4302
		gipiWFireItm.floodZone				= $F("floodZone");
		gipiWFireItm.floodZoneDesc			= escapeHTML2($F("floodZoneDesc"));
		gipiWFireItm.locRisk1				= escapeHTML2($F("locRisk1"));
		gipiWFireItm.cityCd					= escapeHTML2($F("cityCd")); //Gzelle 05282015 SR4302
		gipiWFireItm.city					= escapeHTML2($F("city"));	//Gzelle 05282015 SR4302
		gipiWFireItm.tariffZone				= $F("tariffZone");
		gipiWFireItm.locRisk2				= escapeHTML2($F("locRisk2"));
		gipiWFireItm.districtNo				= $F("districtNo");
		gipiWFireItm.district				= $F("district");
		gipiWFireItm.tarfCd					= $F("tarfCd");
		gipiWFireItm.locRisk3				= escapeHTML2($F("locRisk3"));
		gipiWFireItm.blockId				= $F("blockId");
		gipiWFireItm.constructionCd			= $F("construction");
		gipiWFireItm.front					= escapeHTML2($F("front"));
		gipiWFireItm.riskCd					= $F("riskCd");//($F("risk").split("_"))[1];
		gipiWFireItm.riskDesc				= escapeHTML2($F("risk"));
		gipiWFireItm.constructionRemarks	= escapeHTML2($F("constructionRemarks"));
		gipiWFireItm.right					= escapeHTML2($F("right"));
		gipiWFireItm.occupancyCd			= escapeHTML2($F("occupancyCd")); //Gzelle 05282015 SR4302
		gipiWFireItm.occupancyDesc			= escapeHTML2($F("occupancy"));	//Gzelle 05282015 SR4302
		gipiWFireItm.occupancyRemarks		= escapeHTML2($F("occupancyRemarks"));
		gipiWFireItm.left					= escapeHTML2($F("left"));
		gipiWFireItm.rear					= escapeHTML2($F("rear"));
		gipiWFireItm.blockNo				= $F("block");//$("block").options[$("block").selectedIndex].getAttribute("blockNo");
		gipiWFireItm.latitude				= escapeHTML2($F("txtLatitude")); //Added by Jerome 11.10.2016 SR 5749
		gipiWFireItm.longitude			    = escapeHTML2($F("txtLongitude")); //Added by Jerome 11.10.2016 SR 5749
		
		newObj.gipiWFireItm = gipiWFireItm;
		
		return newObj;
	}catch(e){
		showErrorMessage("setFIItemObject", e);		
	}	
}