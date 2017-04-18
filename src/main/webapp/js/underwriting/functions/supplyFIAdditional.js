/*	Created by	: mark jm 01.28.2011
 * 	Description	: Fill-up fields with values in Fire
 * 	Parameters	: obj - the object that contains the details
 */
function supplyFIAdditional(obj){
	try{		
		$("assignee").value				= obj == null ? "" : unescapeHTML2(nvl(obj.assignee, ""));
		$("eqZone").value				= obj == null ? "" : unescapeHTML2(obj.eqZone);	//Gzelle 02032015
		$("eqZoneDesc").value			= obj == null ? "" : unescapeHTML2(nvl(obj.eqDesc, ""));
		$("frItemType").value			= obj == null ? "" : unescapeHTML2(obj.frItemType);	//Gzelle 02032015
		$("typhoonZone").value			= obj == null ? "" : obj.typhoonZone;
		$("typhoonZoneDesc").value		= obj == null ? "" : unescapeHTML2(nvl(obj.typhoonZoneDesc, ""));
		$("provinceCd").value			= obj == null ? "" : unescapeHTML2(obj.provinceCd);	//Gzelle 02032015
		$("province").value				= obj == null ? "" : unescapeHTML2(obj.provinceDesc);	//Gzelle 02032015
		$("floodZone").value			= obj == null ? "" : unescapeHTML2(obj.floodZone);	//Gzelle 02032015
		$("floodZoneDesc").value		= obj == null ? "" : unescapeHTML2(nvl(obj.floodZoneDesc, ""));
		$("locRisk1").value				= obj == null ? "" : unescapeHTML2(nvl(obj.locRisk1, ""));		
		$("cityCd").value				= obj == null ? "" : unescapeHTML2(obj.cityCd);	//Gzelle 02032015
		$("city").value					= obj == null ? "" : unescapeHTML2(nvl(obj.city,"")); //jeffdojello 01.28.2014
		$("tariffZone").value			= obj == null ? "" : obj.tariffZone;
		$("locRisk2").value				= obj == null ? "" : unescapeHTML2(nvl(obj.locRisk2, ""));
		$("districtNo").value			= obj == null ? "" : unescapeHTML2(obj.districtNo); // Gab 07.31.2015
		$("district").value				= obj == null ? "" : unescapeHTML2(obj.districtNo); // Gab 07.31.2015
		$("tarfCd").value				= obj == null ? "" : unescapeHTML2(obj.tarfCd);	//Gzelle 02032015
		$("locRisk3").value				= obj == null ? "" : unescapeHTML2(nvl(obj.locRisk3, ""));
		$("blockId").value				= obj == null ? "" : unescapeHTML2(obj.blockId); // Gab 07.31.2015
		$("block").value				= obj == null ? "" : unescapeHTML2(obj.blockNo); // Gab 07.31.2015
		$("construction").value			= obj == null ? "" : unescapeHTML2(obj.constructionCd);	//Gzelle 02032015
		$("front").value				= obj == null ? "" : unescapeHTML2(nvl(obj.front, ""));		
		$("riskCd").value				= obj == null ? "" : obj.riskCd;//obj.riskCd != null ? obj.blockId + "_" + obj.riskCd : "";
		$("risk").value					= obj == null ? "" : unescapeHTML2(nvl(obj.riskDesc, ""));
		$("constructionRemarks").value	= obj == null ? "" : unescapeHTML2(nvl(obj.constructionRemarks, ""));
		$("right").value				= obj == null ? "" : unescapeHTML2(nvl(obj.right, ""));
		$("occupancyCd").value			= obj == null ? "" : obj.occupancyCd;
		$("occupancy").value			= obj == null ? "" : unescapeHTML2(obj.occupancyDesc);	//Gzelle 02032015
		$("occupancyRemarks").value		= obj == null ? "" : unescapeHTML2(nvl(obj.occupancyRemarks, ""));
		$("left").value					= obj == null ? "" : unescapeHTML2(nvl(obj.left, ""));
		$("rear").value					= obj == null ? "" : unescapeHTML2(nvl(obj.rear, ""));
		$("txtLatitude").value 			= obj == null ? "" : unescapeHTML2(nvl(obj.latitude,"")); //Added by Jerome 11.10.2016 SR 5749
		$("txtLongitude").value 		= obj == null ? "" : unescapeHTML2(nvl(obj.longitude,"")); //Added by Jerome 11.10.2016 SR 5749
		
		obj != null ? null : setFIAddlFormDefault();
		
		//fireEvent($("block"), "change");		
		
		//($$("div#itemInformationDiv [changed=changed]")).invoke("removeAttribute", "changed");		
	}catch(e){
		showErrorMessage("supplyFIAdditional", e);
		//showMessageBox("supplyFIAdditional : " + e.message);
	}
}