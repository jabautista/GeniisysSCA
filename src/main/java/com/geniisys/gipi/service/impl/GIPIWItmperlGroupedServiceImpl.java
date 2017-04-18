package com.geniisys.gipi.service.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.JSONUtil;
import com.geniisys.gipi.dao.GIPIWItmperlGroupedDAO;
import com.geniisys.gipi.entity.GIPIWGroupedItems;
import com.geniisys.gipi.entity.GIPIWItem;
import com.geniisys.gipi.entity.GIPIWItmperlGrouped;
import com.geniisys.gipi.entity.GIPIWPolbas;
import com.geniisys.gipi.service.GIPIWItmperlGroupedService;
import com.seer.framework.util.StringFormatter;

public class GIPIWItmperlGroupedServiceImpl implements GIPIWItmperlGroupedService{

	private GIPIWItmperlGroupedDAO gipiWItmperlGroupedDAO;

	public GIPIWItmperlGroupedDAO getGipiWItmperlGroupedDAO() {
		return gipiWItmperlGroupedDAO;
	}

	public void setGipiWItmperlGroupedDAO(
			GIPIWItmperlGroupedDAO gipiWItmperlGroupedDAO) {
		this.gipiWItmperlGroupedDAO = gipiWItmperlGroupedDAO;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWItmperlGrouped> getGipiWItmperlGrouped(Integer parId,
			Integer itemNo) throws SQLException {
		return (List<GIPIWItmperlGrouped>) StringFormatter.escapeHTMLInList(this.gipiWItmperlGroupedDAO.getGipiWItmperlGrouped(parId, itemNo));
	}

	@Override
	public String isExist(Integer parId, Integer itemNo) throws SQLException {
		return this.gipiWItmperlGroupedDAO.isExist(parId, itemNo);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWItmperlGrouped> getGipiWItmperlGrouped2(Integer parId)
			throws SQLException {
		return (List<GIPIWItmperlGrouped>) StringFormatter.replaceQuotesInList(this.gipiWItmperlGroupedDAO.getGipiWItmperlGrouped2(parId));
	}

	@Override
	public void negateDeleteItemGroup(Map<String, Object> params)
			throws SQLException, JSONException {
		HttpServletRequest request = (HttpServletRequest) params.get("request");
		JSONObject objParams = new JSONObject((String) request.getParameter("parameters"));
		
		GIPIWPolbas gipiWPolbas = new GIPIWPolbas(new JSONObject(objParams.getString("gipiWPolbas")));
		GIPIWItem gipiWItem = new GIPIWItem(new JSONObject(objParams.getString("gipiWItem")));		
		GIPIWGroupedItems gipiWGroupedItems = new GIPIWGroupedItems(new JSONObject(objParams.getString("gipiWGroupedItems")));
		//DateFormat formatter = new SimpleDateFormat("MM-dd-yyyy HH:mm:ss");
		
		params.put("parId", gipiWPolbas.getParId());
		params.put("lineCd", gipiWPolbas.getLineCd());
		params.put("sublineCd", gipiWPolbas.getSublineCd());
		params.put("issCd", gipiWPolbas.getIssCd());
		params.put("issueYy", gipiWPolbas.getIssueYy());
		params.put("polSeqNo", gipiWPolbas.getPolSeqNo());
		params.put("renewNo", Integer.parseInt(gipiWPolbas.getRenewNo()));
		params.put("effDate", gipiWPolbas.getEffDate());
		params.put("compSw", gipiWPolbas.getCompSw());
		params.put("prorateFlag", gipiWPolbas.getProrateFlag());
		params.put("endtExpiryDate", gipiWPolbas.getEndtExpiryDate());
		params.put("itemNo", gipiWItem.getItemNo());
		params.put("changedTag", gipiWItem.getChangedTag());
		params.put("itemProrateFlag", gipiWItem.getProrateFlag());
		params.put("itemCompSw", gipiWItem.getCompSw());
		params.put("itemFromDate", gipiWItem.getFromDate());
		params.put("itemToDate", gipiWItem.getToDate());
		params.put("groupedItemNo", Integer.parseInt(gipiWGroupedItems.getGroupedItemNo()));
		params.put("grpFromDate", gipiWGroupedItems.getFromDate());
		params.put("grpToDate", gipiWGroupedItems.getToDate());
		params.put("gipiWItem", gipiWItem);
		params.put("gipiWGroupedItems", gipiWGroupedItems);
		//params.put("premAmt", null);
		//params.put("tsiAmt", null);
		//params.put("annPremAmt", null);
		//params.put("annTsiAmt", null);		
		params.put("delGroupedItemRows", this.prepareGIPIWItmperlGroupedForDelete(new JSONArray(objParams.getString("delGroupedItemRows"))));
		
		params.remove("request");
		
		this.getGipiWItmperlGroupedDAO().negateDeleteItemGroupNew(params);
	}	
	
	public void untagDeleteItemGroup(Map<String, Object> params) throws SQLException, JSONException {
		HttpServletRequest request = (HttpServletRequest) params.get("request");
		JSONObject objParams = new JSONObject((String) request.getParameter("parameters"));
		GIPIWPolbas gipiWPolbas = new GIPIWPolbas(new JSONObject(objParams.getString("gipiWPolbas")));
		GIPIWItem gipiWItem = new GIPIWItem(new JSONObject(objParams.getString("gipiWItem")));		
		GIPIWGroupedItems gipiWGroupedItems = new GIPIWGroupedItems(new JSONObject(objParams.getString("gipiWGroupedItems")));
		//DateFormat formatter = new SimpleDateFormat("MM-dd-yyyy HH:mm:ss");
		
		params.put("parId", gipiWPolbas.getParId());
		params.put("lineCd", gipiWPolbas.getLineCd());
		params.put("sublineCd", gipiWPolbas.getSublineCd());
		params.put("issCd", gipiWPolbas.getIssCd());
		params.put("issueYy", gipiWPolbas.getIssueYy());
		params.put("polSeqNo", gipiWPolbas.getPolSeqNo());
		params.put("renewNo", Integer.parseInt(gipiWPolbas.getRenewNo()));
		params.put("effDate", gipiWPolbas.getEffDate());
		params.put("compSw", gipiWPolbas.getCompSw());
		params.put("prorateFlag", gipiWPolbas.getProrateFlag());
		params.put("endtExpiryDate", gipiWPolbas.getEndtExpiryDate());
		params.put("itemNo", gipiWItem.getItemNo());
		params.put("changedTag", gipiWItem.getChangedTag());
		params.put("itemProrateFlag", gipiWItem.getProrateFlag());
		params.put("itemCompSw", gipiWItem.getCompSw());
		params.put("itemFromDate", gipiWItem.getFromDate());
		params.put("itemToDate", gipiWItem.getToDate());
		params.put("groupedItemNo", Integer.parseInt(gipiWGroupedItems.getGroupedItemNo()));
		params.put("grpFromDate", gipiWGroupedItems.getFromDate());
		params.put("grpToDate", gipiWGroupedItems.getToDate());
		params.put("gipiWItem", gipiWItem);
		params.put("gipiWGroupedItems", gipiWGroupedItems);
		params.put("delGroupedItemRows", this.prepareGIPIWItmperlGroupedForDelete(new JSONArray(objParams.getString("delGroupedItemRows"))));
		params.remove("request");
		
		this.getGipiWItmperlGroupedDAO().untagDeleteItemGroup(params);
	}
	
	@Override
	public String checkIfBackEndt(Map<String, Object> params)
			throws SQLException, JSONException {
		HttpServletRequest request = (HttpServletRequest) params.get("request");
		JSONObject objParams = new JSONObject((String) request.getParameter("parameters"));
		GIPIWPolbas gipiWPolbas = new GIPIWPolbas(new JSONObject(objParams.getString("gipiWPolbas")));
		GIPIWItem gipiWItem = new GIPIWItem(new JSONObject(objParams.getString("gipiWItem")));		
		GIPIWGroupedItems gipiWGroupedItems = new GIPIWGroupedItems(new JSONObject(objParams.getString("gipiWGroupedItems")));
		
		params.put("lineCd", gipiWPolbas.getLineCd());
		params.put("sublineCd", gipiWPolbas.getSublineCd());
		params.put("issCd", gipiWPolbas.getIssCd());
		params.put("issueYy", gipiWPolbas.getIssueYy());
		params.put("polSeqNo", gipiWPolbas.getPolSeqNo());
		params.put("renewNo", Integer.parseInt(gipiWPolbas.getRenewNo()));
		params.put("effDate", gipiWPolbas.getEffDate());
		params.put("itemNo", gipiWItem.getItemNo());
		params.put("groupedItemNo", Integer.parseInt(gipiWGroupedItems.getGroupedItemNo()));
		
		params.remove("request");
		
		return this.getGipiWItmperlGroupedDAO().checkIfBackEndt(params);
	}
	
	public List<Map<String, Object>> prepareGIPIWItmperlGroupedForDelete(JSONArray delRows) throws JSONException {
		List<Map<String, Object>> delList = new ArrayList<Map<String,Object>>();
		Map<String, Object> delMap = null;
		JSONObject objItmperlGrouped = null;
		
		System.out.println("No. of perils to be deleted: "+delRows.length());
		for(int i=0, length=delRows.length(); i < length; i++){
			delMap = new HashMap<String, Object>();
			objItmperlGrouped = delRows.getJSONObject(i);
			
			delMap.put("parId", objItmperlGrouped.isNull("parId") ? null : objItmperlGrouped.getInt("parId"));
			delMap.put("itemNo", objItmperlGrouped.isNull("itemNo") ? null : objItmperlGrouped.getInt("itemNo"));
			delMap.put("groupedItemNo", objItmperlGrouped.isNull("groupedItemNo") ? null : objItmperlGrouped.getInt("groupedItemNo"));
			delMap.put("lineCd", objItmperlGrouped.isNull("lineCd") ? null : objItmperlGrouped.getString("lineCd"));
			delMap.put("perilCd", objItmperlGrouped.isNull("perilCd") ? null : objItmperlGrouped.getInt("perilCd"));
			delList.add(delMap);
		}
		
		return delList;
	}

	@Override
	public List<GIPIWItmperlGrouped> prepareGIPIWItmperlGroupedForInsertUpdate(
			JSONArray setRows) throws JSONException, ParseException {
		List<GIPIWItmperlGrouped> itmperlGroupedList = new ArrayList<GIPIWItmperlGrouped>();
		GIPIWItmperlGrouped gipiWItmperlGrouped = null;
		JSONObject objWItmperlGrouped = null;
		
		for(int i=0, length=setRows.length(); i < length; i++){
			gipiWItmperlGrouped = new GIPIWItmperlGrouped();
			objWItmperlGrouped = setRows.getJSONObject(i);
			
			gipiWItmperlGrouped.setParId(objWItmperlGrouped.isNull("parId") ? null : objWItmperlGrouped.getInt("parId"));
			gipiWItmperlGrouped.setItemNo(objWItmperlGrouped.isNull("itemNo") ? null : objWItmperlGrouped.getInt("itemNo"));
			gipiWItmperlGrouped.setGroupedItemNo(objWItmperlGrouped.isNull("groupedItemNo") ? null : objWItmperlGrouped.getInt("groupedItemNo"));
			gipiWItmperlGrouped.setLineCd(objWItmperlGrouped.isNull("lineCd") ? null : objWItmperlGrouped.getString("lineCd"));
			gipiWItmperlGrouped.setPerilCd(objWItmperlGrouped.isNull("perilCd") ? null : objWItmperlGrouped.getString("perilCd"));
			gipiWItmperlGrouped.setRecFlag(objWItmperlGrouped.isNull("recFlag") ? null : objWItmperlGrouped.getString("recFlag"));
			gipiWItmperlGrouped.setNoOfDays(objWItmperlGrouped.isNull("noOfDays") ? null : objWItmperlGrouped.getString("noOfDays"));
			gipiWItmperlGrouped.setPremRt(objWItmperlGrouped.isNull("premRt") || objWItmperlGrouped.getString("premRt").equals("") ? null : objWItmperlGrouped.getString("premRt"));
			gipiWItmperlGrouped.setTsiAmt(objWItmperlGrouped.isNull("tsiAmt") || objWItmperlGrouped.getString("tsiAmt").equals("") ? null : new BigDecimal(objWItmperlGrouped.getString("tsiAmt").replaceAll(",", "")));
			gipiWItmperlGrouped.setPremAmt(objWItmperlGrouped.isNull("premAmt") || objWItmperlGrouped.getString("premAmt").equals("") ? null : new BigDecimal(objWItmperlGrouped.getString("premAmt").replaceAll(",", "")));
			gipiWItmperlGrouped.setAnnTsiAmt(objWItmperlGrouped.isNull("annTsiAmt") || objWItmperlGrouped.getString("annTsiAmt").equals("") ? null : new BigDecimal(objWItmperlGrouped.getString("annTsiAmt").replaceAll(",", "")));
			gipiWItmperlGrouped.setAnnPremAmt(objWItmperlGrouped.isNull("annPremAmt") || objWItmperlGrouped.getString("annPremAmt").equals("") ? null : new BigDecimal(objWItmperlGrouped.getString("annPremAmt").replaceAll(",", "")));
			gipiWItmperlGrouped.setAggregateSw(objWItmperlGrouped.isNull("aggregateSw") ? null : objWItmperlGrouped.getString("aggregateSw"));
			gipiWItmperlGrouped.setBaseAmt(objWItmperlGrouped.isNull("baseAmt") || objWItmperlGrouped.getString("baseAmt").equals("") ? null : new BigDecimal(objWItmperlGrouped.getString("baseAmt").replaceAll(",", "")));
			gipiWItmperlGrouped.setRiCommRate(objWItmperlGrouped.isNull("riCommRate") || objWItmperlGrouped.getString("riCommRate").equals("") ? null : new BigDecimal(objWItmperlGrouped.getString("riCommRate")));
			gipiWItmperlGrouped.setRiCommAmt(objWItmperlGrouped.isNull("riCommAmt") || objWItmperlGrouped.getString("riCommAmt").equals("") ? null : new BigDecimal(objWItmperlGrouped.getString("riCommAmt").replaceAll(",", "")));
			gipiWItmperlGrouped.setWcSw(objWItmperlGrouped.isNull("wcSw") ? null : objWItmperlGrouped.getString("wcSw"));			
			
			itmperlGroupedList.add(gipiWItmperlGrouped);
			gipiWItmperlGrouped = null;
		}
		
		return itmperlGroupedList;
	}	
	
	@Override
	public JSONObject getEndtCoveragePerilAmounts(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", Integer.parseInt(request.getParameter("parId")));				
		params.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
		params.put("groupedItemNo", Integer.parseInt(request.getParameter("groupedItemNo")));
		params.put("perilCd", request.getParameter("perilCd"));
		params.put("perilType", request.getParameter("perilType"));
		params.put("premRt", request.getParameter("premRt") != null && !request.getParameter("premRt").equals("") ? new BigDecimal(request.getParameter("premRt").replaceAll(",", "")) : null);
		params.put("tsiAmt", request.getParameter("tsiAmt") != null && !request.getParameter("tsiAmt").equals("") ? new BigDecimal(request.getParameter("tsiAmt").replaceAll(",", "")) : null);
		params.put("annTsiAmt", request.getParameter("annTsiAmt") != null && !request.getParameter("annTsiAmt").equals("") ? new BigDecimal(request.getParameter("annTsiAmt").replaceAll(",", "")) : null);
		params.put("premAmt", request.getParameter("premAmt") != null && !request.getParameter("premAmt").equals("") ? new BigDecimal(request.getParameter("premAmt").replaceAll(",", "")) : null);
		params.put("annPremAmt", request.getParameter("annPremAmt") != null && !request.getParameter("annPremAmt").equals("") ? new BigDecimal(request.getParameter("annPremAmt").replaceAll(",", "")) : null);
		/*params.put("itemTsiAmt", request.getParameter("itemTsiAmt") != null && !request.getParameter("itemTsiAmt").equals("") ? new BigDecimal(request.getParameter("itemTsiAmt").replaceAll(",", "")) : null);
		params.put("itemAnnTsiAmt", request.getParameter("itemAnnTsiAmt") != null && !request.getParameter("itemAnnTsiAmt").equals("") ? new BigDecimal(request.getParameter("itemAnnTsiAmt").replaceAll(",", "")) : null);
		params.put("itemPremAmt", request.getParameter("itemPremAmt") != null && !request.getParameter("itemPremAmt").equals("") ? new BigDecimal(request.getParameter("itemPremAmt").replaceAll(",", "")) : null);
		params.put("itemAnnPremAmt", request.getParameter("itemAnnPremAmt") != null && !request.getParameter("itemAnnPremAmt").equals("") ? new BigDecimal(request.getParameter("itemAnnPremAmt").replaceAll(",", "")) : null);*/		
		params.put("riCommRate", request.getParameter("riCommRate") != null && !request.getParameter("riCommRate").equals("") ? new BigDecimal(request.getParameter("riCommRate").replaceAll(",", "")) : null);
		params.put("riCommAmt", request.getParameter("riCommAmt") != null && !request.getParameter("riCommAmt").equals("") ? new BigDecimal(request.getParameter("riCommAmt").replaceAll(",", "")) : null);
		params.put("backEndt", request.getParameter("backEndt"));
		
		this.gipiWItmperlGroupedDAO.getEndtCoveragePerilAmounts(params);
		JSONObject json = new JSONObject(params);		
		return json;
	}

	@Override
	public void deleteWItmperlGrouped(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", Integer.parseInt(request.getParameter("parId")));
		params.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
		params.put("groupedItemNo", Integer.parseInt(request.getParameter("groupedItemNo")));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issueYy", request.getParameter("issueYy"));
		params.put("polSeqNo", request.getParameter("polSeqNo"));
		params.put("renewNo", request.getParameter("renewNo"));
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
		this.getGipiWItmperlGroupedDAO().deleteWItmperlGrouped(params);
	}

	@Override
	public HashMap<String, Object> getCoverageVars(Map<String, Object> params)
			throws SQLException {
		return this.getGipiWItmperlGroupedDAO().getCoverageVars(params);
	}

	@Override
	public String checkOpenAlliedPeril(
			HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", Integer.parseInt(request.getParameter("parId")));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("issueYy", request.getParameter("issueYy"));
		params.put("polSeqNo", request.getParameter("polSeqNo"));
		params.put("renewNo", request.getParameter("renewNo"));
		params.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
		params.put("groupedItemNo", Integer.parseInt(request.getParameter("groupedItemNo")));
		params.put("expiryDate", request.getParameter("expiryDate"));
		params.put("perilCd", Integer.parseInt(request.getParameter("perilCd")));
		return this.getGipiWItmperlGroupedDAO().checkOpenAlliedPeril(params);
	}

	@Override
	public void saveCoverage(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		JSONObject paramsObj = new JSONObject(request.getParameter("parameters"));
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(paramsObj.getString("setRows")), userId, GIPIWItmperlGrouped.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(paramsObj.getString("delRows")), userId, GIPIWItmperlGrouped.class));
		params.put("setWcRows", JSONUtil.prepareMapListFromJSON(new JSONArray(paramsObj.getString("setWcRows"))));
		params.put("parId", request.getParameter("parId"));
		params.put("itemNo", request.getParameter("itemNo"));
		params.put("groupedItemNo", request.getParameter("groupedItemNo"));
		params.put("tsiAmt", request.getParameter("tsiAmt"));
		params.put("premAmt", request.getParameter("premAmt"));
		params.put("annTsiAmt", request.getParameter("annTsiAmt"));
		params.put("annPremAmt", request.getParameter("annPremAmt"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("issueYy", request.getParameter("issueYy"));
		params.put("polSeqNo", request.getParameter("polSeqNo"));
		params.put("renewNo", request.getParameter("renewNo"));
		params.put("effDate", request.getParameter("effDate"));
		params.put("itmperilExist", request.getParameter("itmperilExist"));
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
		this.getGipiWItmperlGroupedDAO().saveCoverage(params, userId);
	}

	@Override
	public Map<String, Object> computeTsi(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("tsiAmt", request.getParameter("tsiAmt"));
		params.put("premRt", request.getParameter("premRt"));
		params.put("annTsiAmt", request.getParameter("annTsiAmt"));
		params.put("annPremAmt", request.getParameter("annPremAmt"));
		params.put("dspTsiAmt", request.getParameter("dspTsiAmt"));
		params.put("dspPremAmt", request.getParameter("dspPremAmt"));
		params.put("dspAnnTsiAmt", request.getParameter("dspAnnTsiAmt"));
		params.put("dspAnnPremAmt", request.getParameter("dspAnnPremAmt"));
		params.put("provPremPct", request.getParameter("provPremPct"));
		params.put("provPremTag", request.getParameter("provPremTag"));
		params.put("premAmt", request.getParameter("premAmt"));
		params.put("oldTsiAmt", request.getParameter("oldTsiAmt"));
		params.put("oldPremAmt", request.getParameter("oldPremAmt"));
		params.put("oldPremRt", request.getParameter("oldPremRt"));
		params.put("changedTag", request.getParameter("changedTag"));
		params.put("perilType", request.getParameter("perilType"));
		params.put("prorateFlag", request.getParameter("prorateFlag"));
		params.put("compSw", request.getParameter("compSw"));
		params.put("shortRtPct", request.getParameter("shortRtPct"));
		params.put("parId", Integer.parseInt(request.getParameter("parId")));
		params.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
		params.put("perilCd", request.getParameter("perilCd"));
		params.put("toDate", request.getParameter("toDate"));
		params.put("fromDate", request.getParameter("fromDate"));
		params.put("effDate", request.getParameter("effDate"));
		params.put("endtExpiryDate", request.getParameter("endtExpiryDate"));
		params.put("inceptDate", request.getParameter("inceptDate"));
		params.put("expiryDate", request.getParameter("expiryDate"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("issueYy", request.getParameter("issueYy"));
		params.put("polSeqNo", request.getParameter("polSeqNo"));
		params.put("renewNo", request.getParameter("renewNo"));
		return this.getGipiWItmperlGroupedDAO().computeTsi(params);
	}

	@Override
	public Map<String, Object> computePremium(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("premAmt", request.getParameter("premAmt"));
		params.put("tsiAmt", request.getParameter("tsiAmt"));
		params.put("annPremAmt", request.getParameter("annPremAmt"));
		params.put("dspPremAmt", request.getParameter("dspPremAmt"));
		params.put("dspAnnPremAmt", request.getParameter("dspAnnPremAmt"));
		params.put("provPremPct", request.getParameter("provPremPct"));
		params.put("provPremTag", request.getParameter("provPremTag"));
		params.put("annTsiAmt", request.getParameter("annTsiAmt"));
		params.put("oldPremAmt", request.getParameter("oldPremAmt"));
		params.put("premRt", request.getParameter("premRt"));
		params.put("changedTag", request.getParameter("changedTag"));
		params.put("prorateFlag", request.getParameter("prorateFlag"));
		params.put("fromDate", request.getParameter("fromDate"));
		params.put("toDate", request.getParameter("toDate"));
		params.put("effDate", request.getParameter("effDate"));
		params.put("endtExpiryDate", request.getParameter("endtExpiryDate"));
		params.put("inceptDate", request.getParameter("inceptDate"));
		params.put("expiryDate", request.getParameter("expiryDate"));
		params.put("compSw", request.getParameter("compSw"));
		params.put("shortRtPercent", request.getParameter("shortRtPercent"));
		params.put("parId", Integer.parseInt(request.getParameter("parId")));
		params.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("issueYy", request.getParameter("issueYy"));
		params.put("polSeqNo", request.getParameter("polSeqNo"));
		params.put("renewNo", request.getParameter("renewNo"));
		params.put("perilCd", request.getParameter("perilCd"));
		return this.getGipiWItmperlGroupedDAO().computePremium(params);
	}

	@Override
	public Map<String, Object> autoComputePremRt(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", request.getParameter("parId"));
		params.put("premAmt", request.getParameter("premAmt"));
		params.put("tsiAmt", request.getParameter("tsiAmt"));
		params.put("prorateFlag", request.getParameter("prorateFlag"));
		params.put("premRt", request.getParameter("premRt"));   
		return this.getGipiWItmperlGroupedDAO().autoComputePremRt(params);
	}

	@Override
	public Map<String, Object> validateAllied(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("perilCd", request.getParameter("perilCd"));
		params.put("perilType", request.getParameter("perilType"));
		params.put("bascPerlCd", request.getParameter("bascPerlCd"));
		params.put("tsiAmt", request.getParameter("tsiAmt"));
		params.put("premAmt", request.getParameter("premAmt"));
		params.put("parId", request.getParameter("parId"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("issueYy", request.getParameter("issueYy"));
		params.put("polSeqNo", request.getParameter("polSeqNo"));
		params.put("renewNo", request.getParameter("renewNo"));
		params.put("postSw", request.getParameter("postSw"));
		params.put("tsiLimitSw", request.getParameter("tsiLimitSw"));
		params.put("annTsiAmt", request.getParameter("annTsiAmt"));
		params.put("oldTsiAmt", request.getParameter("oldTsiAmt"));
		params.put("itemNo", request.getParameter("itemNo"));
		params.put("groupedItemNo", request.getParameter("groupedItemNo"));
		params.put("effDate", request.getParameter("effDate"));
		params.put("expiryDate", request.getParameter("expiryDate"));
		params.put("perilList", request.getParameter("perilList"));
		params.put("perilCount", request.getParameter("perilCount"));
		params.put("backEndt", request.getParameter("backEndt"));
		return this.getGipiWItmperlGroupedDAO().validateAllied(params);
	}

	@Override
	public Map<String, Object> deleteItmPerl(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("perilCd", request.getParameter("perilCd"));
		params.put("perilType", request.getParameter("perilType"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("itemNo", request.getParameter("itemNo"));
		params.put("groupedItemNo", request.getParameter("groupedItemNo"));
		params.put("bascPerlCd", request.getParameter("bascPerlCd"));
		params.put("recFlag", request.getParameter("recFlag"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("issueYy", request.getParameter("issueYy"));
		params.put("polSeqNo", request.getParameter("polSeqNo"));
		params.put("renewNo", request.getParameter("renewNo"));
		params.put("effDate", request.getParameter("effDate"));
		params.put("expiryDate", request.getParameter("expiryDate"));
		params.put("perilList", request.getParameter("perilList"));
		params.put("perilCount", request.getParameter("perilCount"));
		return this.getGipiWItmperlGroupedDAO().deleteItmperl(params);
	}

	@Override
	public int checkDuration(String date1, String date2) throws SQLException {
		return this.gipiWItmperlGroupedDAO.checkDuration(date1,date2);
	}
}
