function supplyQuoteFIAdditional(obj){
	try{
		$("assignee").value				= obj == null ? "" : unescapeHTML2(nvl(obj.assignee, ""));
		$("eqZone").value				= obj == null ? "" : obj.eqZone;
		$("eqZoneDesc").value			= obj == null ? "" : obj.eqDesc;
		$("frItemType").value			= obj == null ? "" : obj.frItemType;
		$("typhoonZone").value			= obj == null ? "" : obj.typhoonZone;
		$("typhoonZoneDesc").value		= obj == null ? "" : obj.typhoonZoneDesc;
		$("provinceCd").value			= obj == null ? "" : obj.provinceCd;
		$("province").value				= obj == null ? "" : obj.provinceDesc;
		$("floodZone").value			= obj == null ? "" : obj.floodZone;
		$("floodZoneDesc").value		= obj == null ? "" : obj.floodZoneDesc;
		$("locRisk1").value				= obj == null ? "" : unescapeHTML2(nvl(obj.locRisk1, ""));		
		$("cityCd").value				= obj == null ? "" : obj.cityCd;
		$("city").value					= obj == null ? "" : obj.city;
		$("tariffZone").value			= obj == null ? "" : obj.tariffZone;
		$("locRisk2").value				= obj == null ? "" : unescapeHTML2(nvl(obj.locRisk2, ""));
		$("districtNo").value			= obj == null ? "" : obj.districtNo;
		$("district").value				= obj == null ? "" : obj.districtNo;
		$("tarfCd").value				= obj == null ? "" : obj.tariffCd;
		$("locRisk3").value				= obj == null ? "" : unescapeHTML2(nvl(obj.locRisk3, ""));
		$("blockId").value				= obj == null ? "" : obj.blockId;
		$("block").value				= obj == null ? "" : obj.blockNo;
		$("construction").value			= obj == null ? "" : obj.constructionCd;
		$("front").value				= obj == null ? "" : unescapeHTML2(nvl(obj.front, ""));		
		$("riskCd").value				= obj == null ? "" : obj.riskCd;//obj.riskCd != null ? obj.blockId + "_" + obj.riskCd : "";
		$("risk").value					= obj == null ? "" : unescapeHTML2(nvl(obj.riskDesc, ""));
		$("constructionRemarks").value	= obj == null ? "" : unescapeHTML2(nvl(obj.constructionRemarks, ""));
		$("right").value				= obj == null ? "" : unescapeHTML2(nvl(obj.right, ""));
		$("occupancyCd").value			= obj == null ? "" : obj.occupancyCd;
		$("occupancy").value			= obj == null ? "" : obj.occupancyDesc;
		$("occupancyRemarks").value		= obj == null ? "" : unescapeHTML2(nvl(obj.occupancyRemarks, ""));
		$("left").value					= obj == null ? "" : unescapeHTML2(nvl(obj.left, ""));
		$("rear").value					= obj == null ? "" : unescapeHTML2(nvl(obj.rear, ""));
		$("fromDate").value				= obj == null ? "" : nvl(dateFormat(obj.dateFrom, "mm-dd-yyyy"), "");
		$("toDate").value				= obj == null ? "" : nvl(dateFormat(obj.dateTo, "mm-dd-yyyy"), "");
		/*Added by MarkS 02/08/2017 SR5918*/
		$("latitude").value	= obj == null ? "" : unescapeHTML2(nvl(obj.latitude, ""));
		$("longitude").value	= obj == null ? "" : unescapeHTML2(nvl(obj.longitude, ""));
		
		
		//obj != null ? null : setFIAddlFormDefault();
		//fireEvent($("block"), "change");		
		
		//($$("div#itemInformationDiv [changed=changed]")).invoke("removeAttribute", "changed");	
	}catch(e){
		showErrorMessage("supplyQuoteFIAdditional", e);
	}
}