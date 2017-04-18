package com.geniisys.common.service.impl;

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

import com.geniisys.common.dao.GIISS219DAO;
import com.geniisys.common.service.GIISS219Service;
import com.geniisys.framework.util.TableGridUtil;
import com.seer.framework.util.StringFormatter;

public class GIISS219ServiceImpl implements GIISS219Service{
	
	private GIISS219DAO giiss219DAO;
	
	/**
	 * @return the giiss219DAO
	 */
	public GIISS219DAO getGiiss219DAO() {
		return giiss219DAO;
	}

	/**
	 * @param giiss219dao the giiss219DAO to set
	 */
	public void setGiiss219DAO(GIISS219DAO giiss219dao) {
		giiss219DAO = giiss219dao;
	}

	@Override
	public JSONObject showGiiss219(HttpServletRequest request,
			String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", request.getParameter("type").equals("regular") ? "getGiiss219RecListRegular" : "getGiiss219RecListPackage");
		params.put("userId", userId);
		params.put("planCd", request.getParameter("planCd"));
		params.put("planDesc", request.getParameter("planDesc"));
		params.put("packLineCd", request.getParameter("packLineCd"));
		params.put("packSublineCd", request.getParameter("packSublineCd"));
		params.put("lineName", request.getParameter("lineName"));
		params.put("sublineName", request.getParameter("sublineName"));
		params.put("perilName", request.getParameter("perilName"));
		params.put("mode", request.getParameter("mode"));
		Map<String, Object> map = TableGridUtil.getTableGrid(request, params);			
		return new JSONObject(StringFormatter.escapeHTMLInMap(map));
	}
	
	@Override
	public void saveGiiss219(HttpServletRequest request, String userId)
			throws SQLException, Exception, JSONException {
		JSONObject objParams = new JSONObject(request.getParameter("params"));
		JSONObject objParams2 = new JSONObject(request.getParameter("params2"));
		Map<String, Object> params = new HashMap<String, Object>();
		if (objParams.has("giisPlan")) {
			System.out.println("steven test:::: giisPlan");
			params.put("setGIISPlan", prepareGIISPlanParams(new JSONArray(objParams.getString("giisPlan")),userId,"set"));
			params.put("delGIISPlan", prepareGIISPlanParams(new JSONArray(objParams.getString("giisPlan")),userId,"del"));
		}
		if (objParams.has("giisPackPlan")) {
			System.out.println("steven test:::: giisPackPlan");
			params.put("setGIISPackPlan", prepareGIISPackPlanParams(new JSONArray(objParams.getString("giisPackPlan")),userId,"set"));
			params.put("delGIISPackPlan", prepareGIISPackPlanParams(new JSONArray(objParams.getString("giisPackPlan")),userId,"del"));
		}
		params.put("setGIISPlanDtl", prepareGIISPlanDtlParams(new JSONArray(objParams2.getString("setGIISPlanDtl")),userId,"set"));
		params.put("delGIISPlanDtl", prepareGIISPlanDtlParams(new JSONArray(objParams2.getString("delGIISPlanDtl")),userId,"del"));
		
		params.put("setGIISPackPlanCover", prepareGIISPackPlanCoverParams(new JSONArray(objParams2.getString("setGIISPackPlanCover")),userId,"set"));
		params.put("delGIISPackPlanCover", prepareGIISPackPlanCoverParams(new JSONArray(objParams2.getString("delGIISPackPlanCover")),userId,"del"));
		params.put("setGIISPackPlanCoverDtl", prepareGIISPackPlanCoverDtlParams(new JSONArray(objParams2.getString("setGIISPackPlanCoverDtl")),userId,"set"));
		params.put("delGIISPackPlanCoverDtl", prepareGIISPackPlanCoverDtlParams(new JSONArray(objParams2.getString("delGIISPackPlanCoverDtl")),userId,"del"));
		params.put("appUser", userId);
		this.giiss219DAO.saveGiiss219(params);
	}

	private Object prepareGIISPlanParams(JSONArray jsonArray, String userId, String mode) throws JSONException {
		List<Map<String, Object>> paramList = new ArrayList<Map<String,Object>>();
		for (int i = 0; i < jsonArray.length(); i++) {
			Map<String, Object> paramMap = new HashMap<String, Object>();
			JSONObject rec = jsonArray.getJSONObject(i);
			if (mode.equals("set") && (rec.getString("recordStatus").equals("0") || rec.getString("recordStatus").equals("1"))) {
				paramMap.put("planCd", rec.getString("planCd"));
				paramMap.put("planDesc", StringEscapeUtils.unescapeHtml(StringFormatter.unescapeBackslash(rec.getString("planDesc"))).replaceAll("u000a", "\\\n"));
				paramMap.put("lineCd", StringEscapeUtils.unescapeHtml(StringFormatter.unescapeBackslash(rec.getString("lineCd"))).replaceAll("u000a", "\\\n"));
				paramMap.put("sublineCd", StringEscapeUtils.unescapeHtml(StringFormatter.unescapeBackslash(rec.getString("sublineCd"))).replaceAll("u000a", "\\\n"));
				paramMap.put("remarks", StringEscapeUtils.unescapeHtml(StringFormatter.unescapeBackslash(rec.getString("remarks"))).replaceAll("u000a", "\\\n"));
				paramMap.put("userId", userId);
				
				if (rec.has("giisPlanDtl")) {
					paramMap.put("setGIISPlanDtl", prepareGIISPlanDtlParams(new JSONArray(rec.getString("giisPlanDtl")),userId,"set"));
				}
				paramList.add(paramMap);
			}else if (mode.equals("del") && rec.getString("recordStatus").equals("-1")) {
				paramMap.put("planCd", rec.getString("planCd"));
				paramMap.put("planDesc", StringEscapeUtils.unescapeHtml(StringFormatter.unescapeBackslash(rec.getString("planDesc"))).replaceAll("u000a", "\\\n"));
				paramMap.put("lineCd", StringEscapeUtils.unescapeHtml(StringFormatter.unescapeBackslash(rec.getString("lineCd"))).replaceAll("u000a", "\\\n"));
				paramMap.put("sublineCd", StringEscapeUtils.unescapeHtml(StringFormatter.unescapeBackslash(rec.getString("sublineCd"))).replaceAll("u000a", "\\\n"));
				paramMap.put("remarks", StringEscapeUtils.unescapeHtml(StringFormatter.unescapeBackslash(rec.getString("remarks"))).replaceAll("u000a", "\\\n"));
				paramMap.put("userId", userId);
				paramList.add(paramMap);
			}
		}
		return paramList;
	}
	
	private Object prepareGIISPlanDtlParams(JSONArray jsonArray, String userId, String mode) throws JSONException {
		List<Map<String, Object>> paramList = new ArrayList<Map<String,Object>>();
		for (int i = 0; i < jsonArray.length(); i++) {
			Map<String, Object> paramMap = new HashMap<String, Object>();
			JSONObject rec = jsonArray.getJSONObject(i);
			if (mode.equals("set") && (rec.getString("recordStatus").equals("0") || rec.getString("recordStatus").equals("1"))) {
				paramMap.put("planCd", rec.getString("planCd"));
				paramMap.put("perilCd", rec.getString("perilCd"));
				paramMap.put("premRt", rec.getString("premRt"));
				paramMap.put("premAmt", rec.getString("premAmt"));
				paramMap.put("noOfDays", rec.getString("noOfDays"));
				paramMap.put("baseAmt", rec.getString("baseAmt"));
				paramMap.put("tsiAmt", rec.getString("tsiAmt"));
				paramMap.put("lineCd", rec.getString("lineCd"));
				paramMap.put("aggregateSw", rec.getString("aggregateSw"));
				paramMap.put("userId", userId);
				paramList.add(paramMap);
			}else if (mode.equals("del") && rec.getString("recordStatus").equals("-1")) {
				paramMap.put("planCd", rec.getString("planCd"));
				paramMap.put("perilCd", rec.getString("perilCd"));
				paramMap.put("premRt", rec.getString("premRt"));
				paramMap.put("premAmt", rec.getString("premAmt"));
				paramMap.put("noOfDays", rec.getString("noOfDays"));
				paramMap.put("baseAmt", rec.getString("baseAmt"));
				paramMap.put("tsiAmt", rec.getString("tsiAmt"));
				paramMap.put("lineCd", rec.getString("lineCd"));
				paramMap.put("aggregateSw", rec.getString("aggregateSw"));
				paramMap.put("userId", userId);
				paramList.add(paramMap);
			}
		}
		return paramList;
	}
	
	private Object prepareGIISPackPlanParams(JSONArray jsonArray, String userId, String mode) throws JSONException {
		List<Map<String, Object>> paramList = new ArrayList<Map<String,Object>>();
		for (int i = 0; i < jsonArray.length(); i++) {
			Map<String, Object> paramMap = new HashMap<String, Object>();
			JSONObject rec = jsonArray.getJSONObject(i);
			if (mode.equals("set") && (rec.getString("recordStatus").equals("0") || rec.getString("recordStatus").equals("1"))) {
				paramMap.put("planCd", rec.getString("planCd"));
				paramMap.put("planDesc", StringEscapeUtils.unescapeHtml(StringFormatter.unescapeBackslash(rec.getString("planDesc"))).replaceAll("u000a", "\\\n"));
				paramMap.put("packLineCd", StringEscapeUtils.unescapeHtml(StringFormatter.unescapeBackslash(rec.getString("packLineCd"))).replaceAll("u000a", "\\\n"));
				paramMap.put("packSublineCd", StringEscapeUtils.unescapeHtml(StringFormatter.unescapeBackslash(rec.getString("packSublineCd"))).replaceAll("u000a", "\\\n"));
				paramMap.put("remarks", StringEscapeUtils.unescapeHtml(StringFormatter.unescapeBackslash(rec.getString("remarks"))).replaceAll("u000a", "\\\n"));
				paramMap.put("userId", userId);
				if (rec.has("giisPackPlanCover")) {
					paramMap.put("setGIISPackPlanCover", prepareGIISPackPlanCoverParams(new JSONArray(rec.getString("giisPackPlanCover")),userId,"set"));
				}
				paramList.add(paramMap);
			}else if (mode.equals("del") && rec.getString("recordStatus").equals("-1")) {
				paramMap.put("planCd", rec.getString("planCd"));
				paramMap.put("planDesc", StringEscapeUtils.unescapeHtml(StringFormatter.unescapeBackslash(rec.getString("planDesc"))).replaceAll("u000a", "\\\n"));
				paramMap.put("packLineCd", StringEscapeUtils.unescapeHtml(StringFormatter.unescapeBackslash(rec.getString("packLineCd"))).replaceAll("u000a", "\\\n"));
				paramMap.put("packSublineCd", StringEscapeUtils.unescapeHtml(StringFormatter.unescapeBackslash(rec.getString("packSublineCd"))).replaceAll("u000a", "\\\n"));
				paramMap.put("remarks", StringEscapeUtils.unescapeHtml(StringFormatter.unescapeBackslash(rec.getString("remarks"))).replaceAll("u000a", "\\\n"));
				paramMap.put("userId", userId);
				paramList.add(paramMap);
			}
		}
		return paramList;
	}
	
	private Object prepareGIISPackPlanCoverParams(JSONArray jsonArray,
			String userId, String mode) throws JSONException {
		List<Map<String, Object>> paramList = new ArrayList<Map<String,Object>>();
		for (int i = 0; i < jsonArray.length(); i++) {
			Map<String, Object> paramMap = new HashMap<String, Object>();
			JSONObject rec = jsonArray.getJSONObject(i);
			if (mode.equals("set") && (rec.getString("recordStatus").equals("0") || rec.getString("recordStatus").equals("1"))) {
				paramMap.put("planCd", rec.getString("planCd"));
				paramMap.put("packLineCd",  StringEscapeUtils.unescapeHtml(StringFormatter.unescapeBackslash(rec.getString("packLineCd"))).replaceAll("u000a", "\\\n"));
				paramMap.put("packSublineCd",  StringEscapeUtils.unescapeHtml(StringFormatter.unescapeBackslash(rec.getString("packSublineCd"))).replaceAll("u000a", "\\\n"));
				paramMap.put("userId", userId);
				if (rec.has("giisPackPlanCoverDtl")) {
					paramMap.put("setGIISPackPlanCoverDtl", prepareGIISPackPlanCoverDtlParams(new JSONArray(rec.getString("giisPackPlanCoverDtl")),userId,"set"));
				}
				paramList.add(paramMap);
			}else if (mode.equals("del") && rec.getString("recordStatus").equals("-1")) {
				paramMap.put("planCd", rec.getString("planCd"));
				paramMap.put("packLineCd",  StringEscapeUtils.unescapeHtml(StringFormatter.unescapeBackslash(rec.getString("packLineCd"))).replaceAll("u000a", "\\\n"));
				paramMap.put("packSublineCd",  StringEscapeUtils.unescapeHtml(StringFormatter.unescapeBackslash(rec.getString("packSublineCd"))).replaceAll("u000a", "\\\n"));
				paramMap.put("userId", userId);
				paramList.add(paramMap);
			}
		}
		return paramList;
	}
	
	private Object prepareGIISPackPlanCoverDtlParams(JSONArray jsonArray,
			String userId, String mode) throws JSONException {
		List<Map<String, Object>> paramList = new ArrayList<Map<String,Object>>();
		for (int i = 0; i < jsonArray.length(); i++) {
			Map<String, Object> paramMap = new HashMap<String, Object>();
			JSONObject rec = jsonArray.getJSONObject(i);
			if (mode.equals("set") && (rec.getString("recordStatus").equals("0") || rec.getString("recordStatus").equals("1"))) {
				paramMap.put("planCd", rec.getString("planCd"));
				paramMap.put("perilCd", rec.getString("perilCd"));
				paramMap.put("premRt", rec.getString("premRt"));
				paramMap.put("premAmt", rec.getString("premAmt"));
				paramMap.put("noOfDays", rec.getString("noOfDays"));
				paramMap.put("baseAmt", rec.getString("baseAmt"));
				paramMap.put("tsiAmt", rec.getString("tsiAmt"));
				paramMap.put("packLineCd",  StringEscapeUtils.unescapeHtml(StringFormatter.unescapeBackslash(rec.getString("packLineCd"))).replaceAll("u000a", "\\\n"));
				paramMap.put("packSublineCd",  StringEscapeUtils.unescapeHtml(StringFormatter.unescapeBackslash(rec.getString("packSublineCd"))).replaceAll("u000a", "\\\n"));
				paramMap.put("aggregateSw", rec.getString("aggregateSw"));
				paramMap.put("userId", userId);
				paramList.add(paramMap);
			}else if (mode.equals("del") && rec.getString("recordStatus").equals("-1")) {
				paramMap.put("planCd", rec.getString("planCd"));
				paramMap.put("perilCd", rec.getString("perilCd"));
				paramMap.put("premRt", rec.getString("premRt"));
				paramMap.put("premAmt", rec.getString("premAmt"));
				paramMap.put("noOfDays", rec.getString("noOfDays"));
				paramMap.put("baseAmt", rec.getString("baseAmt"));
				paramMap.put("tsiAmt", rec.getString("tsiAmt"));
				paramMap.put("packLineCd",  StringEscapeUtils.unescapeHtml(StringFormatter.unescapeBackslash(rec.getString("packLineCd"))).replaceAll("u000a", "\\\n"));
				paramMap.put("packSublineCd",  StringEscapeUtils.unescapeHtml(StringFormatter.unescapeBackslash(rec.getString("packSublineCd"))).replaceAll("u000a", "\\\n"));
				paramMap.put("aggregateSw", rec.getString("aggregateSw"));
				paramMap.put("userId", userId);
				paramList.add(paramMap);
			}
		}
		return paramList;
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("packLineCd", request.getParameter("packLineCd"));
		params.put("packSublineCd", request.getParameter("packSublineCd"));
		params.put("recId", request.getParameter("recId"));
		params.put("recId2", request.getParameter("recId2"));
		params.put("mode", request.getParameter("mode"));
		this.giiss219DAO.valAddRec(params);
	}
	
	@Override
	public void valDeleteRec(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("packLineCd", request.getParameter("packLineCd"));
		params.put("packSublineCd", request.getParameter("packSublineCd"));
		params.put("recId", request.getParameter("recId"));
		this.giiss219DAO.valDeleteRec(params);
	}
}
