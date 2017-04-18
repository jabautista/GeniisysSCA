function fillItemInfoUsingObject(selectedObj){
	$("itemNo").value = selectedObj.itemNo.toPaddedString(10);
	$("itemNo2").value = unescapeHTML2(selectedObj.itemTitle);
	$("propertyDesc").value = unescapeHTML2(selectedObj.itemDesc);
	$("provinceCd").value = selectedObj.provinceCd;
	$("province").value = unescapeHTML2(selectedObj.province); //added unescape by robert 11.04.2014
	$("cityCd").value = selectedObj.cityCd;
	$("city").value = unescapeHTML2(selectedObj.city); //added unescape by robert 11.04.2014
	$("district").value = unescapeHTML2(selectedObj.districtNo); //added unescape by robert 11.04.2014
	$("block").value = unescapeHTML2(selectedObj.blockNo); //added unescape by robert 11.04.2014
	$("location").value = unescapeHTML2(selectedObj.locRisk1);
	$("location2").value = unescapeHTML2(selectedObj.locRisk2);
	$("location3").value = unescapeHTML2(selectedObj.locRisk3);
	//$("approvedBy").value = selectedObj.approvedBy;	    
	$("eqZone").value = selectedObj.eqZone == null ? "" : selectedObj.eqZone; //added condition by robert 11.04.2014
	$("typhoonZone").value = selectedObj.typhoonZone == null ? "" : selectedObj.typhoonZone; //added condition by robert 11.04.2014
	$("floodZone").value = selectedObj.floodZone == null ? "" : selectedObj.floodZone; //added condition by robert 11.04.2014
	$("construction").value = selectedObj.constructionCd == null ? "" : selectedObj.constructionCd; //added condition by robert 11.04.2014
	$("constRmrk").value = unescapeHTML2(selectedObj.constructionRemarks); //added unescape by robert 08.13.2014
	$("occupancy").value = selectedObj.occupancyCd == null ? "" : selectedObj.occupancyCd; //added condition by robert 11.04.2014
	$("occRmrk").value =  unescapeHTML2(unescapeHTML2(selectedObj.occupancyRemarks)); //added unescapeHTML2 jeffdojello 06262013
	//$("dateApproved").value = (selectedObj.dateApproved == "" || selectedObj.dateApproved == null) ? "" : dateFormat(selectedObj.dateApproved, "mm-dd-yyyy");
	$("tsiAmt").value = formatCurrency(nvl(selectedObj.tsiAmt, 0));
	$("premRt").value = formatToNineDecimal(nvl(selectedObj.premRate, 0));
	$("tariffCd").value = selectedObj.tarfCd == null || selectedObj.tarfCd == null ? "" : selectedObj.tarfCd ;
	$("tariffZn").value = selectedObj.tariffZone == null || selectedObj.tariffZone == null ? "" : selectedObj.tariffZone; 
	$("bndrFrnt").value = unescapeHTML2(unescapeHTML2(selectedObj.front));//added unescapeHTML2 jeffdojello 06262013
	$("right").value = unescapeHTML2(unescapeHTML2(selectedObj.right));//added unescapeHTML2 jeffdojello 06262013
	$("left").value = unescapeHTML2(unescapeHTML2(selectedObj.left));//added unescapeHTML2 jeffdojello 06262013
	$("rear").value = unescapeHTML2(unescapeHTML2(selectedObj.rear)); //added unescapeHTML2 jeffdojello 06262013
	/*Added by MarkS 02/10/2017 SR5919*/
	$("txtLatitude").value = unescapeHTML2(unescapeHTML2(selectedObj.latitude)); //added unescapeHTML2 jeffdojello 06262013
	$("txtLongitude").value = unescapeHTML2(unescapeHTML2(selectedObj.longitude)); //added unescapeHTML2 jeffdojello 06262013
	/* end SR5919*/
	//$("remarks").value = unescapeHTML2(unescapeHTML2(selectedObj.remarks)); //added unescapeHTML2 jeffdojello 06262013 remove by steven 9.19.2013
}