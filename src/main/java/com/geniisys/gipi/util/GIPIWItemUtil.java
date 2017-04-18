package com.geniisys.gipi.util;

import java.math.BigDecimal;
import java.math.MathContext;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringEscapeUtils;
import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.gipi.entity.GIPIWItem;
import com.seer.framework.util.StringFormatter;

public class GIPIWItemUtil {
	
	private static Logger log = Logger.getLogger(GIPIWItemUtil.class);
	
	public static Map<String, Object> prepareGipiWItemForInsertUpdate(final HttpServletRequest request){
		Map<String, Object> gipiWItemMap = new HashMap<String, Object>();
		
		String[] itemNos		= request.getParameterValues("itemItemNos");
		
		if(itemNos != null){								
			gipiWItemMap.put("lineCds", request.getParameter("lineCd")/*lineCds*/);
			gipiWItemMap.put("sublineCds", request.getParameter("sublineCd")/*sublineCds*/);
			gipiWItemMap.put("parIds", request.getParameterValues("itemParIds"));
			gipiWItemMap.put("itemNos", itemNos);
			gipiWItemMap.put("itemTitles", request.getParameterValues("itemItemTitles"));
			gipiWItemMap.put("itemGrps", request.getParameterValues("itemItemGrps"));
			gipiWItemMap.put("itemDescs", request.getParameterValues("itemItemDescs"));
			gipiWItemMap.put("itemDesc2s", request.getParameterValues("itemItemDesc2s"));
			gipiWItemMap.put("tsiAmts", request.getParameterValues("itemTsiAmts"));
			gipiWItemMap.put("premAmts", request.getParameterValues("itemPremAmts"));
			gipiWItemMap.put("annPremAmts", request.getParameterValues("itemAnnPremAmts"));
			gipiWItemMap.put("annTsiAmts", request.getParameterValues("itemAnnTsiAmts"));
			gipiWItemMap.put("recFlags", request.getParameterValues("itemRecFlags"));
			gipiWItemMap.put("currencyCds", request.getParameterValues("itemCurrencyCds"));
			gipiWItemMap.put("currencyRts", request.getParameterValues("itemCurrencyRts"));
			gipiWItemMap.put("groupCds", request.getParameterValues("itemGroupCds"));
			gipiWItemMap.put("fromDates", request.getParameterValues("itemFromDates"));
			gipiWItemMap.put("toDates", request.getParameterValues("itemToDates"));
			gipiWItemMap.put("packLineCds", request.getParameterValues("itemPackLineCds"));
			gipiWItemMap.put("packSublineCds", request.getParameterValues("itemPackSublineCds"));
			gipiWItemMap.put("discountSws", request.getParameterValues("itemDiscountSws"));
			gipiWItemMap.put("coverageCds", request.getParameterValues("itemCoverageCds"));
			gipiWItemMap.put("otherInfos", request.getParameterValues("itemOtherInfos"));
			gipiWItemMap.put("surchargeSws", request.getParameterValues("itemSurchargeSws"));
			gipiWItemMap.put("regionCds", request.getParameterValues("itemRegionCds"));
			gipiWItemMap.put("changedTags", request.getParameterValues("itemChangedTags"));
			gipiWItemMap.put("prorateFlags", request.getParameterValues("itemProrateFlags"));
			gipiWItemMap.put("compSws", request.getParameterValues("itemCompSws"));
			gipiWItemMap.put("shortRtPercents", request.getParameterValues("itemShortRtPercents"));
			gipiWItemMap.put("packBenCds", request.getParameterValues("itemPackBenCds"));
			gipiWItemMap.put("paytTerms", request.getParameterValues("itemPaytTermss"));
			gipiWItemMap.put("riskNos", request.getParameterValues("itemRiskNos"));
			gipiWItemMap.put("riskItemNos", request.getParameterValues("itemRiskItemNos"));
		}
		
		return gipiWItemMap;
	}
	
	public static Map<String, Object> prepareGipiWItemForDelete(HttpServletRequest request){
		Map<String, Object> gipiWItemMap = new HashMap<String, Object>();
		
		String[] delItemNos	= request.getParameterValues("delItemNos");
		
		if(delItemNos != null){
			String[] delParIds = request.getParameterValues("delParIds");		
			
			gipiWItemMap.put("delParIds", delParIds);
			gipiWItemMap.put("delItemNos", delItemNos);
		}
		
		return gipiWItemMap;
	}
	
	public static List<GIPIWItem> prepareGIPIWItems(final HttpServletRequest request){
		List<GIPIWItem> itemList = new ArrayList<GIPIWItem>();
		
		if(request.getParameterValues("itemItemNos")!= null && request.getParameterValues("itemItemNos").length > 0){
			//String[] lineCds = request.getParameter("lineCd")/*lineCds*/);
			//String[] sublineCds = request.getParameter("sublineCd")/*sublineCds*/);
			String[] parIds 			= request.getParameterValues("itemParIds");
			String[] itemNos 			= request.getParameterValues("itemItemNos");
			String[] itemTitles 		= request.getParameterValues("itemItemTitles");
			String[] itemGrps 			= request.getParameterValues("itemItemGrps");
			String[] itemDescs 			= request.getParameterValues("itemItemDescs");
			String[] itemDesc2s 		= request.getParameterValues("itemItemDesc2s");
			String[] tsiAmts 			= request.getParameterValues("itemTsiAmts");
			String[] premAmts 			= request.getParameterValues("itemPremAmts");
			String[] annPremAmts 		= request.getParameterValues("itemAnnPremAmts");
			String[] annTsiAmts 		= request.getParameterValues("itemAnnTsiAmts");
			String[] recFlags 			= request.getParameterValues("itemRecFlags");
			String[] currencyCds		= request.getParameterValues("itemCurrencyCds");
			String[] currencyRts 		= request.getParameterValues("itemCurrencyRts");
			String[] groupCds 			= request.getParameterValues("itemGroupCds");
			String[] fromDates 			= request.getParameterValues("itemFromDates");
			String[] toDates 			= request.getParameterValues("itemToDates");
			String[] packLineCds 		= request.getParameterValues("itemPackLineCds");
			String[] packSublineCds 	= request.getParameterValues("itemPackSublineCds");
			String[] discountSws 		= request.getParameterValues("itemDiscountSws");
			String[] coverageCds 		= request.getParameterValues("itemCoverageCds");
			String[] otherInfos 		= request.getParameterValues("itemOtherInfos");
			String[] surchargeSws 		= request.getParameterValues("itemSurchargeSws");
			String[] regionCds 			= request.getParameterValues("itemRegionCds");
			String[] changedTags 		= request.getParameterValues("itemChangedTags");
			String[] prorateFlags 		= request.getParameterValues("itemProrateFlags");
			String[] compSws 			= request.getParameterValues("itemCompSws");
			String[] shortRtPercents 	= request.getParameterValues("itemShortRtPercents");
			String[] packBenCds 		= request.getParameterValues("itemPackBenCds");
			String[] paytTerms 			= request.getParameterValues("itemPaytTermss");
			String[] riskNos 			= request.getParameterValues("itemRiskNos");
			String[] riskItemNos 		= request.getParameterValues("itemRiskItemNos");
			
			SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
			for(int i=0, length = itemNos.length; i < length; i++){
				GIPIWItem item = new GIPIWItem();
				try{
					item.setParId(Integer.parseInt(parIds[i]));
					item.setItemNo(Integer.parseInt(itemNos[i]));
					item.setItemTitle(itemTitles[i]);
					item.setItemGrp(itemGrps[i] != null && !(itemGrps[i].isEmpty()) ? Integer.parseInt(itemGrps[i]) : null);
					item.setItemDesc(itemDescs[i]);
					item.setItemDesc2(itemDesc2s[i]);
					item.setTsiAmt(new BigDecimal(tsiAmts[i] != null ? tsiAmts[i].replaceAll(",", "") : "0.00"));
					item.setPremAmt(new BigDecimal(premAmts[i] != null ? premAmts[i].replaceAll(",", "") : "0.00"));
					item.setAnnTsiAmt(new BigDecimal(annTsiAmts[i] != null ? annTsiAmts[i].replaceAll(",", "") : "0.00"));
					item.setAnnPremAmt(new BigDecimal(annPremAmts[i] != null ? annPremAmts[i].replaceAll(",", "") : "0.00"));
					item.setRecFlag(recFlags[i]);
					item.setCurrencyCd(Integer.parseInt(currencyCds[i]));
					item.setCurrencyRt(new BigDecimal(currencyRts[i] != null ? currencyRts[i] : "0.00", MathContext.UNLIMITED));
					item.setGroupCd(groupCds[i] != null && !(groupCds[i].isEmpty()) ? Integer.parseInt(groupCds[i]) : null);
					item.setFromDate(fromDates[i] == null || fromDates[i].isEmpty() || fromDates[i] == "" ? null :sdf.parse(fromDates[i]));
					item.setToDate(toDates[i] == null || toDates[i] == "" || toDates[i].isEmpty() ? null :sdf.parse(toDates[i]));
					item.setPackLineCd(packLineCds[i]);
					item.setPackSublineCd(packSublineCds[i]);
					item.setDiscountSw(discountSws[i]);
					item.setCoverageCd(coverageCds[i] != null && !(coverageCds[i].isEmpty()) ? Integer.parseInt(coverageCds[i]) : null);
					item.setOtherInfo(otherInfos[i]);
					item.setSurchargeSw(surchargeSws[i]);
					item.setRegionCd(regionCds[i] != null && !(regionCds[i].isEmpty()) ? Integer.parseInt(regionCds[i]) : null);
					item.setChangedTag(changedTags[i]);
					item.setProrateFlag(prorateFlags[i]);
					item.setCompSw(compSws[i]);
					item.setShortRtPercent(new BigDecimal(shortRtPercents[i] != null && !(shortRtPercents[i].isEmpty()) ? shortRtPercents[i] : "0.00"));
					item.setPackBenCd(packBenCds[i] != null && !(packBenCds[i].isEmpty()) ? Integer.parseInt(packBenCds[i]) : null);
					item.setPaytTerms(paytTerms[i]);
					item.setRiskNo(riskNos[i] != null && !(riskNos[i].isEmpty()) ? Integer.parseInt(riskNos[i]) : null);
					item.setRiskItemNo(riskItemNos[i] != null && !(riskItemNos[i].isEmpty()) ? Integer.parseInt(riskItemNos[i]) : null);
					itemList.add(item);
				}catch (ParseException e){
					e.printStackTrace();
					log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
				}
			}
		}
		
		return itemList;
	
	}
	
	public static List<GIPIWItem> prepareGIPIWItemForInsert(JSONArray setRows) throws JSONException, ParseException{
		List<GIPIWItem> itemList = new ArrayList<GIPIWItem>();
		SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
		GIPIWItem item = null;
		JSONObject objItem = null;
		
		for(int i=0, length=setRows.length(); i < length; i++){
			item = new GIPIWItem();
			objItem = setRows.getJSONObject(i);
			
			item.setParId(objItem.isNull("parId") ? null : objItem.getInt("parId"));
			item.setItemNo(objItem.isNull("itemNo") ? null : objItem.getInt("itemNo"));
			item.setItemTitle(objItem.isNull("itemTitle") ? null : StringEscapeUtils.unescapeHtml(objItem.getString("itemTitle")));
			item.setItemGrp(objItem.isNull("itemGrp") ? null : objItem.getInt("itemGrp"));
			item.setItemDesc(objItem.isNull("itemDesc") ? null : StringEscapeUtils.unescapeHtml(objItem.getString("itemDesc")));
			item.setItemDesc2(objItem.isNull("itemDesc2") ? null : StringEscapeUtils.unescapeHtml(objItem.getString("itemDesc2")));
			item.setTsiAmt(objItem.isNull("tsiAmt") ? null : new BigDecimal(objItem.getString("tsiAmt").replaceAll(",", "")));
			item.setPremAmt(objItem.isNull("premAmt") ? null : new BigDecimal(objItem.getString("premAmt").replaceAll(",", "")));
			item.setAnnTsiAmt(objItem.isNull("annTsiAmt") ? null : new BigDecimal(objItem.getString("annTsiAmt").replaceAll(",", "")));
			item.setAnnPremAmt(objItem.isNull("annPremAmt") ? null : new BigDecimal(objItem.getString("annPremAmt").replaceAll(",", "")));			
			item.setRecFlag(objItem.isNull("recFlag") ? null : objItem.getString("recFlag"));
			item.setCurrencyCd(objItem.isNull("currencyCd") ? null : objItem.getInt("currencyCd"));
			item.setCurrencyRt(objItem.isNull("currencyRt") ? null : new BigDecimal(objItem.getString("currencyRt").replaceAll(",", "")));
			item.setCoverageCd(objItem.isNull("coverageCd") ? null : objItem.getInt("coverageCd"));
			item.setGroupCd(objItem.isNull("groupCd") ? null : objItem.getInt("groupCd"));
			item.setRegionCd(objItem.isNull("regionCd") ? null : objItem.getInt("regionCd"));
			item.setOtherInfo(objItem.isNull("otherInfo") ? null : StringEscapeUtils.unescapeHtml(objItem.getString("otherInfo")));
			item.setFromDate(objItem.isNull("fromDate") ? null : sdf.parse(objItem.getString("fromDate")));
			item.setToDate(objItem.isNull("toDate") ? null : sdf.parse(objItem.getString("toDate")));
			item.setDiscountSw(objItem.isNull("discountSw") ? null : objItem.getString("discountSw"));
			item.setSurchargeSw(objItem.isNull("surchargeSw") ? null : objItem.getString("surchargeSw"));
			item.setPackLineCd(objItem.isNull("packLineCd") ? null : objItem.getString("packLineCd"));
			item.setPackSublineCd(objItem.isNull("packSublineCd") ? null : objItem.getString("packSublineCd"));
			item.setRiskNo(objItem.isNull("riskNo") ? null : objItem.getInt("riskNo"));
			item.setRiskItemNo(objItem.isNull("riskItemNo") ? null : objItem.getInt("riskItemNo"));
			item.setPaytTerms(objItem.isNull("payTerms") ? null : objItem.getString("paytTerms"));
			
			itemList.add(item);
			item = null;
		}		
		
		return itemList;		
	}
	
	public static List<Map<String, Object>> prepareGIPIWItemForDelete(JSONArray delRows) throws JSONException {
		List<Map<String, Object>> deleteItemList = new ArrayList<Map<String, Object>>();
		Map<String, Object> deleteMap = null;
		
		for(int i=0, length=delRows.length(); i < length; i++){
			deleteMap = new HashMap<String, Object>();
			deleteMap.put("parId", delRows.getJSONObject(i).isNull("parId") ? null : delRows.getJSONObject(i).getInt("parId"));
			deleteMap.put("itemNo", delRows.getJSONObject(i).isNull("itemNo") ? null : delRows.getJSONObject(i).getInt("itemNo"));
			deleteMap.put("itemGrp", delRows.getJSONObject(i).isNull("itemGrp") ? null : delRows.getJSONObject(i).getInt("itemGrp")); //added by steven 10.21.2013
			
			deleteItemList.add(deleteMap);
			deleteMap = null;
		}		
		
		return deleteItemList;
	}
	
	public static List<Map<String, Object>> prepareGIPIWItemMapForInsert(JSONArray setRows) throws JSONException, ParseException{
		List<Map<String, Object>> itemList = new ArrayList<Map<String, Object>>();
		SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
		for(int i=0; i < setRows.length(); i++){
			Map<String, Object> item = new HashMap<String, Object>();
			JSONObject objItem = setRows.getJSONObject(i);

			item.put("parId", (objItem.isNull("parId") ? null : objItem.getInt("parId")));
			item.put("itemNo", (objItem.isNull("itemNo") ? null : objItem.getInt("itemNo")));
			item.put("itemTitle", (objItem.isNull("itemTitle") ? null : StringFormatter.unescapeHtmlJava(objItem.getString("itemTitle"))));
			item.put("itemGrp", (objItem.isNull("itemGrp") ? null : objItem.getInt("itemGrp")));
			item.put("itemDesc", (objItem.isNull("itemDesc") ? null : StringFormatter.unescapeHtmlJava(objItem.getString("itemDesc"))));
			item.put("itemDesc2", (objItem.isNull("itemDesc2") ? null : StringFormatter.unescapeHtmlJava(objItem.getString("itemDesc2"))));
			item.put("tsiAmt", (objItem.isNull("tsiAmt") ? null : new BigDecimal(objItem.getString("tsiAmt").replaceAll(",", ""))));
			item.put("premAmt", (objItem.isNull("premAmt") ? null : new BigDecimal(objItem.getString("premAmt").replaceAll(",", ""))));
			item.put("annPremAmt", (objItem.isNull("annPremAmt") ? null : new BigDecimal(objItem.getString("annPremAmt").replaceAll(",", ""))));			
			item.put("annTsiAmt", (objItem.isNull("annTsiAmt") ? null : new BigDecimal(objItem.getString("annTsiAmt").replaceAll(",", ""))));
			item.put("recFlag", (objItem.isNull("recFlag") ? null : objItem.getString("recFlag")));
			item.put("currencyCd", (objItem.isNull("currencyCd") ? null : objItem.getInt("currencyCd")));
			item.put("currencyRt", (objItem.isNull("currencyRt") ? null : objItem.getString("currencyRt").replaceAll(",", "")));
			item.put("groupCd", (objItem.isNull("groupCd") ? null : objItem.getInt("groupCd")));
			if((objItem.isNull("dateFormatted") ? "N" : objItem.getString("dateFormatted")).equals("Y")){ // added by robert 04.17.2013 to prevent parse error SR 12546
				item.put("fromDate", (objItem.isNull("fromDate") ? null : "".equals(objItem.getString("fromDate")) ? null : sdf.parse(objItem.getString("fromDate"))));
				item.put("toDate", (objItem.isNull("toDate") ? null : "".equals(objItem.getString("toDate")) ? null : sdf.parse(objItem.getString("toDate"))));
			}else{
				item.put("fromDate", (objItem.isNull("strFromDate") ? null : "".equals(objItem.getString("strFromDate")) ? null : sdf.parse(objItem.getString("strFromDate"))));
				item.put("toDate", (objItem.isNull("strToDate") ? null : "".equals(objItem.getString("strToDate")) ? null : sdf.parse(objItem.getString("strToDate"))));
			}
			item.put("packLineCd", (objItem.isNull("packLineCd") ? null : objItem.getString("packLineCd")));
			item.put("packSublineCd", (objItem.isNull("packSublineCd") ? null : objItem.getString("packSublineCd")));
			item.put("discountSw", (objItem.isNull("discountSw") ? null : objItem.getString("discountSw")));
			item.put("surchargeSw", objItem.isNull("surchargeSw") ? null : objItem.getString("surchargeSw"));
			item.put("coverageCd", (objItem.isNull("coverageCd") ? null : objItem.getInt("coverageCd")));
			item.put("otherInfo", (objItem.isNull("otherInfo") ? null : StringEscapeUtils.unescapeHtml(objItem.getString("otherInfo"))));
			item.put("regionCd", (objItem.isNull("regionCd") || objItem.getString("regionCd").equals("null") || objItem.getString("regionCd").equals(null) || objItem.getString("regionCd").equals("") ? null : objItem.getInt("regionCd")));
			item.put("riskNo", (objItem.isNull("riskNo") ? null : objItem.getInt("riskNo")));
			item.put("riskItemNo", (objItem.isNull("riskItemNo") ? null : objItem.getInt("riskItemNo")));
			item.put("paytTerms", (objItem.isNull("paytTerms") ? null : objItem.getString("paytTerms")));
			item.put("packBenCd", (objItem.isNull("packBenCd") ? null : objItem.getInt("packBenCd")));
			//added by d.alcantara, 02-23-2011
			item.put("prorateFlag", (objItem.isNull("prorateFlag") ? null : objItem.getString("prorateFlag")));
			item.put("compSw", (objItem.isNull("compSw") ? null : objItem.getString("compSw")));
			item.put("shortRtPct", (objItem.isNull("shortRtPercent") ? null : objItem.getString("shortRtPercent")));
			//added by nica 07.25.2011
			item.put("recordStatus", (objItem.isNull("recordStatus") ? null : objItem.getString("recordStatus")));
			itemList.add(item);
		}		
		
		return itemList;		
	}
}
