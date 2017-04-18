package com.geniisys.common.service.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringEscapeUtils;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.dao.GIISTariffRatesHdrDAO;
import com.geniisys.common.entity.GIISTariffRatesDtl;
import com.geniisys.common.entity.GIISTariffRatesHdr;
import com.geniisys.common.service.GIISTariffRatesHdrService;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.seer.framework.util.StringFormatter;

public class GIISTariffRatesHdrServiceImpl implements GIISTariffRatesHdrService{
	
	private GIISTariffRatesHdrDAO giisTariffRatesHdrDAO;


	public GIISTariffRatesHdrDAO getGiisTariffRatesHdrDAO() {
		return giisTariffRatesHdrDAO;
	}

	public void setGiisTariffRatesHdrDAO(GIISTariffRatesHdrDAO giisTariffRatesHdrDAO) {
		this.giisTariffRatesHdrDAO = giisTariffRatesHdrDAO;
	}

	@Override
	public GIISTariffRatesHdr getTariffDetailsFI(Map<String, Object> params)
			throws SQLException {
		return getGiisTariffRatesHdrDAO().getTariffDetailsFI(params);
	}
	
	@Override
	public GIISTariffRatesHdr getTariffDetailsMC(Map<String, Object> params)
			throws SQLException {
		return getGiisTariffRatesHdrDAO().getTariffDetailsMC(params);
	}
	
	@Override
	public JSONObject showGiiss106(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss106RecList");	
		params.put("moduleId", request.getParameter("moduleId"));
		params.put("userId", userId);
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(recList);
	}
	
	@Override
	public JSONObject showGiiss106FixedSIList(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss106FixedSIList");	
		params.put("tariffCd", request.getParameter("tariffCd"));
		params.put("userId", userId);
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(recList);
	}
	
//	public JSONObject getGiiss106WithCompDtl(String tariffCd) throws SQLException{ //remove by steven 07.04.2014
//		JSONObject json = new JSONObject(this.giisTariffRatesHdrDAO.getGiiss106WithCompDtl(tariffCd));
//		return json;
//	}
//	
//	public JSONObject getGiiss106FixedPremDtl(String tariffCd) throws SQLException{
//		return new JSONObject(this.giisTariffRatesHdrDAO.getGiiss106FixedPremDtl(tariffCd));
//	}

	@Override
	public void valAddHdrRec(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("perilCd", request.getParameter("perilCd"));
		params.put("tariffZone", request.getParameter("tariffZone"));
		params.put("coverageCd", request.getParameter("coverageCd"));
		params.put("sublineTypeCd", request.getParameter("sublineTypeCd"));
		params.put("motortypeCd", request.getParameter("motortypeCd"));
		params.put("tarfCd", request.getParameter("tarfCd"));
		params.put("constructionCd", request.getParameter("constructionCd"));
		this.giisTariffRatesHdrDAO.valAddHdrRec(params);
	}
	
	@Override
	public void valDeleteHdrRec(String tariffCd) throws SQLException {
		this.giisTariffRatesHdrDAO.valDeleteHdrRec(tariffCd);
	}
	
	public Integer getTariffCdNoSequence() throws SQLException{
		return this.giisTariffRatesHdrDAO.getTariffCdNoSequence();
	}
		
	public void valTariffRatesFixedSIRec(HttpServletRequest request) throws SQLException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("tariffCd", request.getParameter("tariffCd"));
		params.put("tariffDtlCd", request.getParameter("tariffDtlCd"));
		params.put("fixedSI", request.getParameter("fixedSI"));
		
		this.giisTariffRatesHdrDAO.valTariffRatesFixedSIRec(params);
	}
	
//	public JSONObject getGiiss106MinMaxAmt(Integer tariffCd) throws SQLException{
//		return new JSONObject(this.giisTariffRatesHdrDAO.getGiiss106MinMaxAmt(tariffCd));
//	}
	
//	public Integer getNextTariffDtlCd(Integer tariffCd) throws SQLException{
//		return this.giisTariffRatesHdrDAO.getNextTariffDtlCd(tariffCd);
//	}
	
	public void valAddDtlRec(HttpServletRequest request) throws SQLException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("tariffCd", request.getParameter("tariffCd"));
		params.put("higherRange", request.getParameter("higherRange"));
		params.put("lowerRange", request.getParameter("lowerRange"));
		params.put("tariffRate", request.getParameter("tariffRate"));
		params.put("additionalPremium", request.getParameter("additionalPremium"));
		this.giisTariffRatesHdrDAO.valAddDtlRec(params);
	}
	//remove by steven 07.02.2014
	/*public List<GIISTariffRatesDtl> prepareTariffRatesDtlForInsert(JSONArray rows, String userId) throws SQLException, JSONException{
		GIISTariffRatesDtl dtl = null;
		JSONObject json = null;
		List<GIISTariffRatesDtl> items = new ArrayList<GIISTariffRatesDtl>();
		
		for(int i=0; i<rows.length(); i++) {
			json = rows.getJSONObject(i);
			dtl = new GIISTariffRatesDtl();
			Integer tariffCd = json.getInt("tariffCd");
			
			dtl.setTariffCd(json.isNull("tariffCd") || json.get("tariffCd").equals("")? null : tariffCd);
			dtl.setTariffDtlCd(json.isNull("tariffDtlCd") || json.get("tariffDtlCd").equals("")? this.getNextTariffDtlCd(tariffCd) : json.getInt("tariffDtlCd"));
			dtl.setFixedPremium(json.isNull("fixedPremium") || json.get("fixedPremium").equals("")? null : new BigDecimal(json.getString("fixedPremium").replaceAll(",", "")));
			dtl.setFixedSI(json.isNull("fixedSI") || json.get("fixedSI").equals("")? null : new BigDecimal(json.getString("fixedSI").replaceAll(",", "")));
			dtl.setHigherRange(json.isNull("higherRange")  || json.get("higherRange").equals("")? null : new BigDecimal(json.getString("higherRange").replaceAll(",", "")));
			dtl.setLowerRange(json.isNull("lowerRange") || json.get("lowerRange").equals("") ? null : new BigDecimal(json.getString("lowerRange").replaceAll(",", "")));
			dtl.setSiDeductible(json.isNull("siDeductible") || json.get("siDeductible").equals("") ? null : new BigDecimal(json.getString("siDeductible").replaceAll(",", "")));
			dtl.setExcessRate(json.isNull("excessRate") || json.get("excessRate").equals("") ? null : new BigDecimal(json.getString("excessRate").replaceAll(",", "")));
			dtl.setLoadingRate(json.isNull("loadingRate") || json.get("loadingRate").equals("") ? null : new BigDecimal(json.getString("loadingRate").replaceAll(",", "")));
			dtl.setDiscountRate(json.isNull("discountRate") || json.get("discountRate").equals("") ? null : new BigDecimal(json.getString("discountRate").replaceAll(",", "")));
			dtl.setAdditionalPremium(json.isNull("additionalPremium") || json.get("additionalPremium").equals("") ? null : new BigDecimal(json.getString("additionalPremium").replaceAll(",", "")));
			dtl.setTariffRate(json.isNull("tariffRate") ? null : new BigDecimal(json.getString("tariffRate").replaceAll(",", "")));
			dtl.setRemarks(json.isNull("remarks") ? null : StringFormatter.unescapeBackslash(StringEscapeUtils.unescapeHtml(json.getString("remarks"))));
			dtl.setRemarks2(json.isNull("remarks2") ? null : StringFormatter.unescapeBackslash(StringEscapeUtils.unescapeHtml(json.getString("remarks2"))));
			dtl.setUserId(userId);
			
			items.add(dtl);
		}
		
		return items;
	}*/
	

	/*public List<GIISTariffRatesHdr> prepareTariffRatesHdrForInsert(JSONArray rows, String userId) throws SQLException, JSONException{
		GIISTariffRatesHdr hdr = null;
		JSONObject json = null;
		List<GIISTariffRatesHdr> items = new ArrayList<GIISTariffRatesHdr>();
		
		for(int i=0; i<rows.length(); i++) {
			json = rows.getJSONObject(i);
			hdr = new GIISTariffRatesHdr();
			
			hdr.setTariffCd(json.isNull("tariffCd") || json.get("tariffCd").equals("")? this.getTariffCdNoSequence() : json.getInt("tariffCd"));
			hdr.setLineCd(json.isNull("lineCd") ? null : StringFormatter.unescapeBackslash(StringEscapeUtils.unescapeHtml(json.getString("lineCd"))));
			hdr.setSublineCd(json.isNull("sublineCd") ? null : StringFormatter.unescapeBackslash(StringEscapeUtils.unescapeHtml(json.getString("sublineCd"))));
			hdr.setPerilCd(json.isNull("perilCd") ? null : json.getInt("perilCd"));
			hdr.setTariffZone(json.isNull("tariffZone") ? null : StringFormatter.unescapeBackslash(StringEscapeUtils.unescapeHtml(json.getString("tariffZone"))));
			hdr.setCoverageCd(json.isNull("coverageCd") || json.get("coverageCd").equals("") ? null : json.getInt("coverageCd"));
			hdr.setSublineTypeCd(json.isNull("sublineTypeCd") ? null : StringFormatter.unescapeBackslash(StringEscapeUtils.unescapeHtml(json.getString("sublineTypeCd"))));
			hdr.setMotortypeCd(json.isNull("motortypeCd") || json.get("motortypeCd").equals("") ? null : json.getInt("motortypeCd"));
			hdr.setTarfCd(json.isNull("tarfCd") ? null : StringFormatter.unescapeBackslash(StringEscapeUtils.unescapeHtml(json.getString("tarfCd"))));
			hdr.setConstructionCd(json.isNull("constructionCd") ? null : StringFormatter.unescapeBackslash(StringEscapeUtils.unescapeHtml(json.getString("constructionCd"))));
			hdr.setDefaultPremTag(json.isNull("defaultPremTag") ? null : StringFormatter.unescapeBackslash(StringEscapeUtils.unescapeHtml(json.getString("defaultPremTag"))));
			hdr.setRemarks(json.isNull("remarks") ? null : StringFormatter.unescapeBackslash(StringEscapeUtils.unescapeHtml(json.getString("remarks"))));
			hdr.setUserId(userId);
			
			items.add(hdr);
		}
		
		return items;
	}*/
	
	private Object prepareParentParams(JSONArray jsonArray, String userId, String mode) throws JSONException {
		List<GIISTariffRatesHdr> paramList = new ArrayList<GIISTariffRatesHdr>();
		for (int i = 0; i < jsonArray.length(); i++) {
			GIISTariffRatesHdr paramObj = new GIISTariffRatesHdr();
			JSONObject json = jsonArray.getJSONObject(i);
			if (mode.equals("set") && (json.getString("recordStatus").equals("0") || json.getString("recordStatus").equals("1"))) {
				
				paramObj.setTariffCd(json.isNull("tariffCd") || "".equals(json.getString("tariffCd")) ? null : json.getInt("tariffCd"));
				paramObj.setLineCd(json.isNull("lineCd") ? null : StringFormatter.unescapeBackslash(StringEscapeUtils.unescapeHtml(json.getString("lineCd"))));
				paramObj.setSublineCd(json.isNull("sublineCd") ? null : StringFormatter.unescapeBackslash(StringEscapeUtils.unescapeHtml(json.getString("sublineCd"))));
				paramObj.setPerilCd(json.isNull("perilCd") || "".equals(json.getString("perilCd"))  ? null : json.getInt("perilCd"));
				paramObj.setTariffZone(json.isNull("tariffZone") ? null : StringFormatter.unescapeBackslash(StringEscapeUtils.unescapeHtml(json.getString("tariffZone"))));
				paramObj.setCoverageCd(json.isNull("coverageCd") || json.get("coverageCd").equals("") ? null : json.getInt("coverageCd"));
				paramObj.setSublineTypeCd(json.isNull("sublineTypeCd") ? null : StringFormatter.unescapeBackslash(StringEscapeUtils.unescapeHtml(json.getString("sublineTypeCd"))));
				paramObj.setMotortypeCd(json.isNull("motortypeCd") || json.get("motortypeCd").equals("") ? null : json.getInt("motortypeCd"));
				paramObj.setTarfCd(json.isNull("tarfCd") ? null : StringFormatter.unescapeBackslash(StringEscapeUtils.unescapeHtml(json.getString("tarfCd"))));
				paramObj.setConstructionCd(json.isNull("constructionCd") ? null : StringFormatter.unescapeBackslash(StringEscapeUtils.unescapeHtml(json.getString("constructionCd"))));
				paramObj.setDefaultPremTag(json.isNull("defaultPremTag") ? null : StringFormatter.unescapeBackslash(StringEscapeUtils.unescapeHtml(json.getString("defaultPremTag"))));
				paramObj.setRemarks(json.isNull("remarks") ? null : StringFormatter.unescapeBackslash(StringEscapeUtils.unescapeHtml(json.getString("remarks"))));
				paramObj.setUserId(userId);
				paramObj.setRemarks2(json.isNull("remarks2") ? null : StringFormatter.unescapeBackslash(StringEscapeUtils.unescapeHtml(json.getString("remarks2"))));
				paramObj.setFixedPremium(json.isNull("fixedPremium") || "".equals(json.getString("fixedPremium")) ? null : new BigDecimal(json.getString("fixedPremium")));
				paramObj.setSiDeductible(json.isNull("siDeductible") || "".equals(json.getString("siDeductible")) ? null : new BigDecimal(json.getString("siDeductible")));
				paramObj.setExcessRate(json.isNull("excessRate") || "".equals(json.getString("excessRate")) ? null : new BigDecimal(json.getString("excessRate")));
				paramObj.setLoadingRate(json.isNull("loadingRate") || "".equals(json.getString("loadingRate")) ? null : new BigDecimal(json.getString("loadingRate")));
				paramObj.setDiscountRate(json.isNull("discountRate") || "".equals(json.getString("discountRate")) ? null : new BigDecimal(json.getString("discountRate")));
				paramObj.setTariffRate(json.isNull("tariffRate") || "".equals(json.getString("tariffRate")) ? null : new BigDecimal(json.getString("tariffRate")));
				paramObj.setAdditionalPremium(json.isNull("additionalPremium") || "".equals(json.getString("additionalPremium")) ? null : new BigDecimal(json.getString("additionalPremium")));
				paramObj.setTariffDtlCd(json.isNull("tariffDtlCd") || "".equals(json.getString("tariffDtlCd")) ? null : json.getInt("tariffDtlCd"));
				
				if (json.has("tariffRatesFixedSI")) {
					paramObj.setGiisTariffRatesDtl(prepareChildParams(new JSONArray(json.getString("tariffRatesFixedSI")),userId));
				}
				paramList.add(paramObj);
			}else if (mode.equals("del") && json.getString("recordStatus").equals("-1")) {
				paramObj.setTariffCd(json.isNull("tariffCd") || "".equals(json.getString("tariffCd")) ? null : json.getInt("tariffCd"));
				paramList.add(paramObj);
			}
		}
		return paramList;
	}
	
	private Object prepareChildParams(JSONArray jsonArray, String userId) throws JSONException {
		List<GIISTariffRatesDtl> paramList = new ArrayList<GIISTariffRatesDtl>();
		for (int i = 0; i < jsonArray.length(); i++) {
			GIISTariffRatesDtl paramObj = new GIISTariffRatesDtl();
			JSONObject json = jsonArray.getJSONObject(i);
			if (json.getString("recordStatus").equals("0") || json.getString("recordStatus").equals("1")) {
				paramObj.setTariffCd(json.isNull("tariffCd") || "".equals(json.getString("tariffCd")) ? null : json.getInt("tariffCd"));
				paramObj.setTariffDtlCd(json.isNull("tariffDtlCd") || "".equals(json.getString("tariffDtlCd")) ? null : json.getInt("tariffDtlCd"));
				paramObj.setFixedSI(json.isNull("fixedSI") || "".equals(json.getString("fixedSI")) ? null : new BigDecimal(json.getString("fixedSI")));
				paramObj.setFixedPremium(json.isNull("fixedPremium") || "".equals(json.getString("fixedPremium")) ? null : new BigDecimal(json.getString("fixedPremium")));
				paramObj.setHigherRange(json.isNull("higherRange") || "".equals(json.getString("higherRange")) ? null : new BigDecimal(json.getString("higherRange")));
				paramObj.setLowerRange(json.isNull("lowerRange") || "".equals(json.getString("lowerRange")) ? null : new BigDecimal(json.getString("lowerRange")));
				paramObj.setSiDeductible(json.isNull("siDeductible") || "".equals(json.getString("siDeductible")) ? null : new BigDecimal(json.getString("siDeductible")));
				paramObj.setExcessRate(json.isNull("excessRate") || "".equals(json.getString("excessRate")) ? null : new BigDecimal(json.getString("excessRate")));
				paramObj.setLoadingRate(json.isNull("loadingRate") || "".equals(json.getString("loadingRate")) ? null : new BigDecimal(json.getString("loadingRate")));
				paramObj.setDiscountRate(json.isNull("discountRate") || "".equals(json.getString("discountRate")) ? null : new BigDecimal(json.getString("discountRate")));
				paramObj.setTariffRate(json.isNull("tariffRate") || "".equals(json.getString("tariffRate")) ? null : new BigDecimal(json.getString("tariffRate")));
				paramObj.setAdditionalPremium(json.isNull("additionalPremium") || "".equals(json.getString("additionalPremium")) ? null : new BigDecimal(json.getString("additionalPremium")));
				paramObj.setRemarks(json.isNull("remarks") ? null : StringFormatter.unescapeBackslash(StringEscapeUtils.unescapeHtml(json.getString("remarks"))));
				paramObj.setRemarks2(json.isNull("remarks2") ? null : StringFormatter.unescapeBackslash(StringEscapeUtils.unescapeHtml(json.getString("remarks2"))));
				paramObj.setUserId(userId);
				paramList.add(paramObj);
			}
		}
		return paramList;
	}
	
	@Override
	public void saveGiiss106(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		JSONObject objParams = new JSONObject(request.getParameter("params"));
		Map<String, Object> params = new HashMap<String, Object>();
		if (objParams.has("tariffRatesHdr")) {
			params.put("setRows", prepareParentParams(new JSONArray(objParams.getString("tariffRatesHdr")),userId,"set"));
			params.put("delRows", prepareParentParams(new JSONArray(objParams.getString("tariffRatesHdr")),userId,"del"));
		}
//		params.put("setRows", this.prepareTariffRatesHdrForInsert(new JSONArray(request.getParameter("setRows")), userId) );  //remove by steven 07.02.2014
//		params.put("setDtlRows", this.prepareTariffRatesDtlForInsert(new JSONArray(request.getParameter("setDtlRows")), userId) ); //remove by steven 07.02.2014
		params.put("setDtlRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setDtlRows")), userId, GIISTariffRatesDtl.class));
		params.put("delDtlRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delDtlRows")), userId, GIISTariffRatesDtl.class));
		params.put("appUser", userId);
		this.giisTariffRatesHdrDAO.saveGiiss106(params);
	}

	@Override
	public JSONObject getGiiss106AllFixedSIList(HttpServletRequest request,
			String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss106AllFixedSIList");	
		params.put("tariffCd", request.getParameter("tariffCd"));
		params.put("userId", userId);
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(recList);
	}

	@Override
	public JSONObject getGiiss106AllRec(HttpServletRequest request,
			String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss106AllRecList");	
		params.put("moduleId", "GIISS106");
		params.put("userId", userId);
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(recList);
	}
}
