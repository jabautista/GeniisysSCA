package com.geniisys.gipi.util;

import java.math.BigDecimal;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringEscapeUtils;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.gipi.entity.GIPIWGroupedItems;

public class GIPIWGroupedItemsUtil {
	
	public static List<GIPIWGroupedItems> prepareGIPIWGroupedItemsForInsert(JSONArray setRows) throws JSONException {
		List<GIPIWGroupedItems> groupList = new ArrayList<GIPIWGroupedItems>();
		GIPIWGroupedItems gi = null;
		JSONObject objGroupedItems = null;
		
		for(int i=0, length=setRows.length(); i < length; i++){
			gi = new GIPIWGroupedItems();
			objGroupedItems = setRows.getJSONObject(i);
			
			gi.setParId(objGroupedItems.isNull("parId") ? null : objGroupedItems.getString("parId"));
			gi.setItemNo(objGroupedItems.isNull("itemNo") ? null : objGroupedItems.getString("itemNo"));
			gi.setGroupedItemNo(objGroupedItems.isNull("groupedItemNo") ? null : objGroupedItems.getString("groupedItemNo"));
			gi.setGroupedItemTitle(objGroupedItems.isNull("groupedItemTitle") ? null : objGroupedItems.getString("groupedItemTitle"));
			gi.setGroupCd(objGroupedItems.isNull("groupCd") ? null : objGroupedItems.getString("groupCd"));
			gi.setSublineCd(objGroupedItems.isNull("sublineCd") ? null : objGroupedItems.getString("sublineCd"));
			gi.setAmountCovered(objGroupedItems.isNull("amountCovered") ? null : new BigDecimal(objGroupedItems.getString("amountCovered").replaceAll(",", "")));
			gi.setRemarks(objGroupedItems.isNull("remarks") ? null : StringEscapeUtils.unescapeHtml(objGroupedItems.getString("remarks")));
			gi.setIncludeTag(objGroupedItems.isNull("includeTag") ? null : objGroupedItems.getString("includeTag"));
			groupList.add(gi);
			gi = null;
		}
		
		return groupList;
	}
	
	public static List<Map<String, Object>> prepareGIPIWGroupedItemsForDelete(JSONArray delRows) throws JSONException {
		List<Map<String, Object>> delGroupList = new ArrayList<Map<String, Object>>();
		Map<String, Object> delGroupMap = null;
		
		for(int i=0, length=delRows.length(); i < length; i++){
			delGroupMap = new HashMap<String, Object>();
			delGroupMap.put("parId", delRows.getJSONObject(i).isNull("parId") ? null : delRows.getJSONObject(i).getInt("parId"));
			delGroupMap.put("itemNo", delRows.getJSONObject(i).isNull("itemNo") ? null : delRows.getJSONObject(i).getInt("itemNo"));
			delGroupMap.put("groupedItemNo", delRows.getJSONObject(i).isNull("groupedItemNo") ? null : delRows.getJSONObject(i).getInt("groupedItemNo"));
			delGroupMap.put("lineCd",delRows.getJSONObject(i).getString("lineCd"));
			delGroupList.add(delGroupMap);
			delGroupMap = null;
		}		
		
		return delGroupList;
	}
	
	public static List<GIPIWGroupedItems> prepareGIPIWAccGroupedItemsForInsert(JSONArray groupedItemRow) throws JSONException, ParseException{
		List<GIPIWGroupedItems> groupedItemsList = new ArrayList<GIPIWGroupedItems>();
		GIPIWGroupedItems groupedItem = null;
		JSONObject objItem = null;
		DateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
		
		for (int i = 0; i < groupedItemRow.length(); i++){
			groupedItem = new GIPIWGroupedItems();
			objItem = groupedItemRow.getJSONObject(i);
			
			groupedItem.setAge(objItem.isNull("age") || objItem.getString("age").equals("") ? null : objItem.getString("age"));
			groupedItem.setAmountCovered(objItem.isNull("amountCovered") || objItem.getString("amountCovered").equals("") ? null : new BigDecimal(objItem.getString("amountCovered").replaceAll(",", "")));
			groupedItem.setAnnPremAmt(objItem.isNull("annPremAmt") || objItem.getString("annPremAmt").equals("") ? null : new BigDecimal(objItem.getString("annPremAmt").replaceAll(",", "")));
			groupedItem.setAnnTsiAmt(objItem.isNull("annTsiAmt") || objItem.getString("annTsiAmt").equals("") ? null : new BigDecimal(objItem.getString("annTsiAmt").replaceAll(",", "")));
			groupedItem.setCivilStatus(objItem.isNull("civilStatus") ? null : objItem.getString("civilStatus"));
			groupedItem.setControlCd(objItem.isNull("controlCd") ? null : objItem.getString("controlCd"));
			groupedItem.setControlTypeCd(objItem.isNull("controlTypeCd") ? null : objItem.getString("controlTypeCd"));
			groupedItem.setDateOfBirth(objItem.isNull("dateOfBirth") || objItem.getString("dateOfBirth").equals("") ? null : sdf.parse(objItem.getString("dateOfBirth")));
			groupedItem.setDeleteSw(objItem.isNull("deleteSw") ? null : objItem.getString("deleteSw"));
			groupedItem.setFromDate(objItem.isNull("fromDate") || objItem.getString("fromDate").equals("") ? null : sdf.parse(objItem.getString("fromDate")));
			groupedItem.setGroupCd(objItem.isNull("groupCd") ? null : objItem.getString("groupCd"));
			groupedItem.setGroupDesc(objItem.isNull("groupDesc") ? null : objItem.getString("groupDesc"));
			groupedItem.setGroupedItemNo(objItem.isNull("groupedItemNo") ? null : objItem.getString("groupedItemNo"));
			groupedItem.setGroupedItemTitle(objItem.isNull("groupedItemTitle") ? null : objItem.getString("groupedItemTitle"));
			groupedItem.setIncludeTag(objItem.isNull("includeTag") ? null : objItem.getString("includeTag"));
			groupedItem.setItemNo(objItem.isNull("itemNo") ? null : objItem.getString("itemNo"));
			groupedItem.setLineCd(objItem.isNull("lineCd") ? null : objItem.getString("lineCd"));
			groupedItem.setOverwriteBen(objItem.isNull("overwriteBen") ? null : objItem.getString("overwriteBen"));
			groupedItem.setPackageCd(objItem.isNull("packageCd") ? null : objItem.getString("packageCd"));
			groupedItem.setPackBenCd(objItem.isNull("packBenCd") ? null : objItem.getString("packBenCd"));
			groupedItem.setParId(objItem.isNull("parId") ? null : objItem.getString("parId"));
			groupedItem.setPaytTerms(objItem.isNull("paytTerms") ? null : objItem.getString("paytTerms"));
			groupedItem.setPaytTermsDesc(objItem.isNull("paytTermsDesc") ? null : objItem.getString("paytTermsDesc"));
			groupedItem.setPositionCd(objItem.isNull("positionCd") ? null : objItem.getString("positionCd"));
			groupedItem.setPremAmt(objItem.isNull("premAmt") || objItem.getString("premAmt").equals("")? null : new BigDecimal(objItem.getString("premAmt").replace(",", "")));
			groupedItem.setPrincipalCd(objItem.isNull("principalCd") ? null : objItem.getString("principalCd"));
			groupedItem.setRemarks(objItem.isNull("remarks") ? null : objItem.getString("remarks"));
			groupedItem.setSalary(objItem.isNull("salary") || objItem.getString("salary").equals("") ? null : new BigDecimal(objItem.getString("salary").replace(",", "")));
			groupedItem.setSalaryGrade(objItem.isNull("salaryGrade") ? null : objItem.getString("salaryGrade"));
			groupedItem.setSex(objItem.isNull("sex") ? null : objItem.getString("sex"));
			groupedItem.setSublineCd(objItem.isNull("sublineCd") ? null : objItem.getString("sublineCd"));
			groupedItem.setToDate(objItem.isNull("toDate") || objItem.getString("toDate").equals("") ? null : sdf.parse(objItem.getString("toDate")));
			groupedItem.setTsiAmt(objItem.isNull("tsiAmt") || objItem.getString("tsiAmt").equals("") ? null : new BigDecimal(objItem.getString("tsiAmt").replace(",", "")));
			
			groupedItemsList.add(groupedItem);
			groupedItem = null;
		}
		
		return groupedItemsList;
	}
	
	public static List<Map<String, Object>> prepareGIPIWAccGroupedItemsForUpdate(JSONArray groupedItem) throws JSONException{
		List<Map<String, Object>> updateGroupedItemsList = new ArrayList<Map<String,Object>>();
		Map<String, Object> updateGroupedItemsMap = new HashMap<String, Object>();

		JSONObject objGrpItem = null;
		
		for (int i = 0; i < groupedItem.length(); i++){
			objGrpItem = groupedItem.getJSONObject(i);
			
			updateGroupedItemsMap.put("parId", objGrpItem.isNull("parId") ? null : objGrpItem.getString("parId"));
			updateGroupedItemsMap.put("itemNo", objGrpItem.isNull("itemNo") ? null : objGrpItem.getString("itemNo"));
			updateGroupedItemsMap.put("lineCd", objGrpItem.isNull("lineCd") ? null : objGrpItem.getString("lineCd"));
			updateGroupedItemsMap.put("groupedItemNo", objGrpItem.isNull("groupedItemNo") ? null : objGrpItem.getString("groupedItemNo"));
			updateGroupedItemsMap.put("newNoOfPerson", objGrpItem.isNull("newNoOfPerson") ? null : objGrpItem.getInt("newNoOfPerson"));
			updateGroupedItemsMap.put("popBenefitsSw", objGrpItem.isNull("popBenefitsSw") ? null : objGrpItem.getString("popBenefitsSw"));
			updateGroupedItemsMap.put("popBenefitsGroupedItemNo", objGrpItem.isNull("popBenefitsGroupedItemNo") ? null : objGrpItem.getString("popBenefitsGroupedItemNo"));
			updateGroupedItemsMap.put("popBenefitsPackBenCd", objGrpItem.isNull("popBenefitsPackBenCd") ? null : objGrpItem.getString("popBenefitsPackBenCd"));
			
			updateGroupedItemsList.add(updateGroupedItemsMap);
		}
		
		return updateGroupedItemsList;
	}
}
