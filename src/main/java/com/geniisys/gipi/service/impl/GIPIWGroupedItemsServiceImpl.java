package com.geniisys.gipi.service.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringEscapeUtils;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.JSONUtil;
import com.geniisys.gipi.dao.GIPIWGroupedItemsDAO;
import com.geniisys.gipi.entity.GIPIWGroupedItems;
import com.geniisys.gipi.service.GIPIWGroupedItemsService;
import com.geniisys.gipi.util.DateFormatter;
import com.seer.framework.util.StringFormatter;

public class GIPIWGroupedItemsServiceImpl implements GIPIWGroupedItemsService{

	private GIPIWGroupedItemsDAO gipiWGroupedItemsDAO;

	public GIPIWGroupedItemsDAO getGipiWGroupedItemsDAO() {
		return gipiWGroupedItemsDAO;
	}

	public void setGipiWGroupedItemsDAO(GIPIWGroupedItemsDAO gipiWGroupedItemsDAO) {
		this.gipiWGroupedItemsDAO = gipiWGroupedItemsDAO;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWGroupedItems> getGipiWGroupedItems(Integer parId)
			throws SQLException {
		//return (List<GIPIWGroupedItems>) StringFormatter.escapeHTMLJavascriptInList(this.gipiWGroupedItemsDAO.getGipiWGroupedItems(parId)); Gzelle 02262015
		return (List<GIPIWGroupedItems>) StringFormatter.escapeHTMLInList4(this.gipiWGroupedItemsDAO.getGipiWGroupedItems(parId));	
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWGroupedItems> getGipiWGroupedItems2(Integer parId,
			Integer itemNo) throws SQLException {
		//return (List<GIPIWGroupedItems>) StringFormatter.replaceQuotesInList(this.gipiWGroupedItemsDAO.getGipiWGroupedItems2(parId,itemNo));
		return this.gipiWGroupedItemsDAO.getGipiWGroupedItems2(parId,itemNo);  //replaced by: Mark C. 04152015 SR4302
	}

	@Override
	public List<Map<String, Object>> prepareGIPIWGroupedItemsForDelete(
			JSONArray delRows) throws JSONException {
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

	@Override
	public List<GIPIWGroupedItems> prepareGIPIWGroupedItemsForInsertUpdate(JSONArray setRows) throws JSONException, ParseException {
		List<GIPIWGroupedItems> groupedItemsList = new ArrayList<GIPIWGroupedItems>();
		GIPIWGroupedItems groupedItem = null;		
		JSONObject objGroupedItem = null;
		//DateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
		
		for (int i = 0; i < setRows.length(); i++){
			groupedItem = new GIPIWGroupedItems();
			objGroupedItem = setRows.getJSONObject(i);			
			
			groupedItem.setParId(objGroupedItem.isNull("parId") ? null : objGroupedItem.getString("parId"));
			groupedItem.setItemNo(objGroupedItem.isNull("itemNo") ? null : objGroupedItem.getString("itemNo"));
			groupedItem.setGroupedItemNo(objGroupedItem.isNull("groupedItemNo") ? null : objGroupedItem.getString("groupedItemNo"));
			groupedItem.setIncludeTag(objGroupedItem.isNull("includeTag") ? null : objGroupedItem.getString("includeTag"));
			groupedItem.setGroupedItemTitle(objGroupedItem.isNull("groupedItemTitle") ? null : StringEscapeUtils.unescapeHtml(objGroupedItem.getString("groupedItemTitle")));
			groupedItem.setSex(objGroupedItem.isNull("sex") ? null : objGroupedItem.getString("sex"));
			groupedItem.setPositionCd(objGroupedItem.isNull("positionCd") ? null : objGroupedItem.getString("positionCd"));
			groupedItem.setCivilStatus(objGroupedItem.isNull("civilStatus") ? null : objGroupedItem.getString("civilStatus"));
			//groupedItem.setDateOfBirth(objGroupedItem.isNull("dateOfBirth") || objGroupedItem.getString("dateOfBirth").equals("") ? null : sdf.parse(objGroupedItem.getString("dateOfBirth")));
			groupedItem.setDateOfBirth(objGroupedItem.isNull("dateOfBirth") ? null : (objGroupedItem.getString("dateOfBirth").equals("") ? null : DateFormatter.formatDate(objGroupedItem.getString("dateOfBirth"), DateFormatter.MM_D_DD_D_YYYY, DateFormatter.MM_D_DD_D_YYYY)));
			groupedItem.setAge(objGroupedItem.isNull("age") || objGroupedItem.getString("age").equals("") ? null : objGroupedItem.getString("age"));
			groupedItem.setSalary(objGroupedItem.isNull("salary") || objGroupedItem.getString("salary").equals("") ? null : new BigDecimal(objGroupedItem.getString("salary").replace(",", "")));
			//groupedItem.setSalaryGrade(objGroupedItem.isNull("salaryGrade") ? null : objGroupedItem.getString("salaryGrade"));
			groupedItem.setSalaryGrade(objGroupedItem.isNull("salaryGrade") ? null : StringEscapeUtils.unescapeHtml(objGroupedItem.getString("salaryGrade")));  //replaced by Mark C. 04062015 SR4302
			groupedItem.setAmountCovered(objGroupedItem.isNull("amountCovered") || objGroupedItem.getString("amountCovered").equals("") ? null : new BigDecimal(objGroupedItem.getString("amountCovered").replaceAll(",", "")));
			groupedItem.setRemarks(objGroupedItem.isNull("remarks") ? null : StringEscapeUtils.unescapeHtml(objGroupedItem.getString("remarks")));
			groupedItem.setLineCd(objGroupedItem.isNull("lineCd") ? null : objGroupedItem.getString("lineCd"));
			groupedItem.setSublineCd(objGroupedItem.isNull("sublineCd") ? null : objGroupedItem.getString("sublineCd"));
			groupedItem.setDeleteSw(objGroupedItem.isNull("deleteSw") ? null : objGroupedItem.getString("deleteSw"));
			groupedItem.setGroupCd(objGroupedItem.isNull("groupCd") ? null : objGroupedItem.getString("groupCd"));
			//groupedItem.setFromDate(objGroupedItem.isNull("fromDate") || objGroupedItem.getString("fromDate").equals("") ? null : sdf.parse(objGroupedItem.getString("fromDate")));
			//groupedItem.setToDate(objGroupedItem.isNull("toDate") || objGroupedItem.getString("toDate").equals("") ? null : sdf.parse(objGroupedItem.getString("toDate")));
			groupedItem.setFromDate(objGroupedItem.isNull("fromDate") ? null : (objGroupedItem.getString("fromDate").equals("") ? null : DateFormatter.formatDate(objGroupedItem.getString("fromDate"), DateFormatter.MM_D_DD_D_YYYY, DateFormatter.MM_D_DD_D_YYYY)));
			groupedItem.setToDate(objGroupedItem.isNull("toDate") ? null : (objGroupedItem.getString("toDate").equals("") ? null : DateFormatter.formatDate(objGroupedItem.getString("toDate"), DateFormatter.MM_D_DD_D_YYYY, DateFormatter.MM_D_DD_D_YYYY)));			
			groupedItem.setPaytTerms(objGroupedItem.isNull("paytTerms") ? null : objGroupedItem.getString("paytTerms"));
			groupedItem.setPackBenCd(objGroupedItem.isNull("packBenCd") ? null : objGroupedItem.getString("packBenCd"));
			groupedItem.setAnnTsiAmt(objGroupedItem.isNull("annTsiAmt") || objGroupedItem.getString("annTsiAmt").equals("") ? null : new BigDecimal(objGroupedItem.getString("annTsiAmt").replaceAll(",", "")));
			groupedItem.setAnnPremAmt(objGroupedItem.isNull("annPremAmt") || objGroupedItem.getString("annPremAmt").equals("") ? null : new BigDecimal(objGroupedItem.getString("annPremAmt").replaceAll(",", "")));			
			//groupedItem.setControlCd(objGroupedItem.isNull("controlCd") ? null : objGroupedItem.getString("controlCd"));
			groupedItem.setControlCd(objGroupedItem.isNull("controlCd") ? null : StringEscapeUtils.unescapeHtml(objGroupedItem.getString("controlCd"))); //replaced by Mark C. 04062015 SR4302
			groupedItem.setControlTypeCd(objGroupedItem.isNull("controlTypeCd") ? null : objGroupedItem.getString("controlTypeCd"));			
			groupedItem.setTsiAmt(objGroupedItem.isNull("tsiAmt") || objGroupedItem.getString("tsiAmt").equals("") ? null : new BigDecimal(objGroupedItem.getString("tsiAmt").replace(",", "")));
			groupedItem.setPremAmt(objGroupedItem.isNull("premAmt") || objGroupedItem.getString("premAmt").equals("")? null : new BigDecimal(objGroupedItem.getString("premAmt").replace(",", "")));
			groupedItem.setPrincipalCd(objGroupedItem.isNull("principalCd") ? null : objGroupedItem.getString("principalCd"));					
			
			groupedItemsList.add(groupedItem);
			groupedItem = null;
		}
		
		return groupedItemsList;
	}

	@Override
	public void renumberGroupedItems(Map<String, Object> params)
			throws SQLException {
		this.getGipiWGroupedItemsDAO().renumberGroupedItems(params);		
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWGroupedItems> getGIPIWGroupedItems(
			Map<String, Object> params) throws SQLException {		
		//return (List<GIPIWGroupedItems>) StringFormatter.escapeHTMLJavascriptInList(this.getGipiWGroupedItemsDAO().getGIPIWGroupedItems(params));
		return this.getGipiWGroupedItemsDAO().getGIPIWGroupedItems(params); //replaced by: Mark C. 04162015 SR4302
	}

	@Override
	public Map<String, Object> validateGroupedItemNo(Map<String, Object> params)
			throws SQLException {
		return this.getGipiWGroupedItemsDAO().validateGroupedItemNo(params);
	}

	@Override
	public Map<String, Object> validateGroupedItemTitle(
			Map<String, Object> params) throws SQLException {
		return this.getGipiWGroupedItemsDAO().validateGroupedItemTitle(params);
	}

	@Override
	public Map<String, Object> validatePrincipalCd(Map<String, Object> params)
			throws SQLException {
		return this.getGipiWGroupedItemsDAO().validatePrincipalCd(params);
	}

	@Override
	public Map<String, Object> validateGrpFromDate(Map<String, Object> params)
			throws SQLException {
		return this.getGipiWGroupedItemsDAO().validateGrpFromDate(params);
	}

	@Override
	public Map<String, Object> validateGrpToDate(Map<String, Object> params)
			throws SQLException {
		return this.getGipiWGroupedItemsDAO().validateGrpToDate(params);
	}
	
	@Override
	public Map<String, Object> validateAmtCovered(Map<String, Object> params)
			throws SQLException {
		return this.getGipiWGroupedItemsDAO().validateAmtCovered(params);
	}

	@Override
	public HashMap<String, Object> getGroupedItem(Map<String, Object> params)
			throws SQLException {
		return this.getGipiWGroupedItemsDAO().getGroupedItem(params);
	}

	@Override
	public Map<String, Object> getDeleteSwVars(Map<String, Object> params)
			throws SQLException {
		return this.getGipiWGroupedItemsDAO().getDeleteSwVars(params);
	}

	@Override
	public HashMap<String, Object> setGroupedItemsVars(Map<String, Object> params)
			throws SQLException {
		return this.getGipiWGroupedItemsDAO().setGroupedItemsVars(params);
	}

	@Override
	public String validateRetrieveGrpItems(Map<String, Object> params) throws SQLException {
		return this.getGipiWGroupedItemsDAO().validateRetrieveGrpItems(params);
	}

	@Override
	public String preNegateDelete(Map<String, Object> params)
			throws SQLException {
		return this.getGipiWGroupedItemsDAO().preNegateDelete(params);
	}

	@Override
	public String checkBackEndt(Map<String, Object> params) throws SQLException {
		return this.getGipiWGroupedItemsDAO().checkBackEndt(params);
	}

	@Override
	public void negateDelete(HttpServletRequest request, String userId) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issueYy", request.getParameter("issueYy"));
		params.put("polSeqNo", request.getParameter("polSeqNo"));
		params.put("renewNo", request.getParameter("renewNo"));
		params.put("parId", Integer.parseInt(request.getParameter("parId")));
		params.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
		params.put("groupedItemNo", Integer.parseInt(request.getParameter("groupedItemNo")));
		params.put("toDate", request.getParameter("toDate"));
		params.put("fromDate", request.getParameter("fromDate"));
		params.put("effDate", request.getParameter("effDate"));
		params.put("prorateFlag", request.getParameter("prorateFlag"));
		params.put("compSw", request.getParameter("compSw"));
		params.put("endtExpiryDate", request.getParameter("endtExpiryDate"));
		params.put("shortRtPercent", request.getParameter("shortRtPercent"));
		params.put("endtTaxSw", request.getParameter("endtTaxSw"));
		params.put("packLineCd", request.getParameter("packLineCd"));
		params.put("packSublineCd", request.getParameter("packSublineCd"));
		params.put("parStatus", request.getParameter("parStatus"));
		params.put("packPolFlag", request.getParameter("packPolFlag"));
		params.put("userId", userId);
		this.getGipiWGroupedItemsDAO().negateDelete(params);
	}

	@Override
	public void saveGroupedItems(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		JSONObject paramsObj = new JSONObject(request.getParameter("parameters"));
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(paramsObj.getString("setRows")), userId, GIPIWGroupedItems.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(paramsObj.getString("delRows")), userId, GIPIWGroupedItems.class));
		params.put("parId", Integer.parseInt(request.getParameter("parId")));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("issueYy", request.getParameter("issueYy"));
		params.put("polSeqNo", request.getParameter("polSeqNo"));
		params.put("renewNo", request.getParameter("renewNo"));
		params.put("effDate", request.getParameter("effDate"));
		params.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
		params.put("noOfPersons", request.getParameter("noOfPersons"));
		params.put("prorateFlag", request.getParameter("prorateFlag"));
		params.put("compSw", request.getParameter("compSw"));
		params.put("endtExpiryDate", request.getParameter("endtExpiryDate"));
		params.put("shortRtPercent", request.getParameter("shortRtPercent"));
		params.put("endtTaxSw", request.getParameter("endtTaxSw"));
		params.put("packLineCd", request.getParameter("packLineCd"));
		params.put("packSublineCd", request.getParameter("packSublineCd"));
		params.put("parStatus", request.getParameter("parStatus"));
		params.put("packPolFlag", request.getParameter("packPolFlag"));
		params.put("itmperilExist", request.getParameter("itmperilExist"));
		params.put("userId", userId);
		this.getGipiWGroupedItemsDAO().saveGroupedItems(params);
	}

	@Override
	public void insertRetrievedGrpItems(HttpServletRequest request,
			String userId) throws SQLException, JSONException {
		JSONObject paramsObj = new JSONObject(request.getParameter("parameters"));
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(paramsObj.getString("setRows")), userId, GIPIWGroupedItems.class));
		params.put("insertAll", request.getParameter("insertAll"));
		params.put("parId", request.getParameter("parId"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("issueYy", request.getParameter("issueYy"));
		params.put("polSeqNo", request.getParameter("polSeqNo"));
		params.put("renewNo", request.getParameter("renewNo"));
		params.put("itemNo", request.getParameter("itemNo"));
		params.put("effDate", request.getParameter("effDate"));
		params.put("noOfPersons", request.getParameter("noOfPersons"));
		params.put("prorateFlag", request.getParameter("prorateFlag"));
		params.put("compSw", request.getParameter("compSw"));
		params.put("endtExpiryDate", request.getParameter("endtExpiryDate"));
		params.put("shortRtPercent", request.getParameter("shortRtPercent"));
		params.put("endtTaxSw", request.getParameter("endtTaxSw"));
		params.put("packLineCd", request.getParameter("packLineCd"));
		params.put("packSublineCd", request.getParameter("packSublineCd"));
		params.put("parStatus", request.getParameter("parStatus"));
		params.put("packPolFlag", request.getParameter("packPolFlag"));
		params.put("userId", userId);
		this.getGipiWGroupedItemsDAO().insertRetrievedGrpItems(params);
	}
	
	@Override
	public void copyBenefits(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		JSONObject paramsObj = new JSONObject(request.getParameter("parameters"));
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(paramsObj.getString("setRows")), userId, GIPIWGroupedItems.class));
		params.put("parId", request.getParameter("parId"));
		params.put("itemNo", request.getParameter("itemNo"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("issueYy", request.getParameter("issueYy"));
		params.put("polSeqNo", request.getParameter("polSeqNo"));
		params.put("renewNo", request.getParameter("renewNo"));
		params.put("effDate", request.getParameter("effDate"));
		params.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
		params.put("groupedItemNo", request.getParameter("groupedItemNo"));
		params.put("packBenCd", request.getParameter("packBenCd"));
		params.put("copyAll", request.getParameter("copyAll"));
		params.put("effDate", request.getParameter("effDate"));
		params.put("prorateFlag", request.getParameter("prorateFlag"));
		params.put("compSw", request.getParameter("compSw"));
		params.put("endtExpiryDate", request.getParameter("endtExpiryDate"));
		params.put("shortRtPercent", request.getParameter("shortRtPercent"));
		params.put("endtTaxSw", request.getParameter("endtTaxSw"));
		params.put("packLineCd", request.getParameter("packLineCd"));
		params.put("packSublineCd", request.getParameter("packSublineCd"));
		params.put("parStatus", request.getParameter("parStatus"));
		params.put("packPolFlag", request.getParameter("packPolFlag"));
		params.put("userId", userId);
		this.getGipiWGroupedItemsDAO().copyBenefits(params);
	}

	@Override
	public void postSaveGroupedItems(HttpServletRequest request, String userId)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", request.getParameter("parId"));
		params.put("userId", userId);
		params.put("parStatCd", "4");
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("issueYy", request.getParameter("issueYy"));
		params.put("polSeqNo", request.getParameter("polSeqNo"));
		params.put("renewNo", request.getParameter("renewNo"));
		params.put("prorateFlag", request.getParameter("prorateFlag"));
		params.put("compSw", request.getParameter("compSw"));
		params.put("endtExpiryDate", request.getParameter("endtExpiryDate"));
		params.put("effDate", request.getParameter("effDate"));
		params.put("shortRtPercent", request.getParameter("shortRtPercent"));
		this.getGipiWGroupedItemsDAO().postSaveGroupedItems(params);
	}

	@Override
	public Integer checkGroupedItems(Map<String, Object> params)
			throws SQLException {
		return this.getGipiWGroupedItemsDAO().checkGroupedItems(params);
	}

	@Override
	public Integer validateNoOfPersons(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("issueYy", request.getParameter("issueYy"));
		params.put("polSeqNo", request.getParameter("polSeqNo"));
		params.put("renewNo", request.getParameter("renewNo"));
		params.put("itemNo", request.getParameter("itemNo"));
		return this.getGipiWGroupedItemsDAO().validateNoOfPersons(params);
	}
	
	@Override
	public Map<String, Object> getCAGroupedItems(HttpServletRequest request) throws SQLException { //Deo [01.26.2017]: SR-23702
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", Integer.parseInt(request.getParameter("parId")));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("issueYy", Integer.parseInt(request.getParameter("issueYy")));
		params.put("polSeqNo", Integer.parseInt(request.getParameter("polSeqNo")));
		params.put("renewNo", Integer.parseInt(request.getParameter("renewNo")));
		params.put("itemNo", request.getParameter("itemNo"));
		params.put("effDate", request.getParameter("effDate"));
		
		List<?> list = getGipiWGroupedItemsDAO().getCAGroupedItems(params);
		params.put("rows", new JSONArray());
		for (Object o: list) {
			if (o instanceof Map && o != null) {
				params.put("rows", new JSONArray((List<?>) StringFormatter.escapeHTMLInListOfMap(list)));
			}else{
				params.put("rows", new JSONArray((List<?>) StringFormatter.escapeHTMLInList(list)));
			}
			break;
		}
		return params;
	}
}
